import 'package:code_builder/code_builder.dart';
import 'package:typedefx_generator/src/model/generated_library.dart';
import 'package:typedefx_generator/src/template/record_class_template.dart'
    as recordClass;
import 'package:typedefx_generator/src/template/cases_class_template.dart'
    as casesClass;

Library inflate(GeneratedLibrary library) {
  final lib = LibraryBuilder()..directives.addAll(_imports(library));
  library.records.forEach((it) => lib.body.add(recordClass.inflate(it)));
  library.cases.forEach((it) => lib.body.addAll(casesClass.inflate(it)));
  if (library.exportOriginalUri) {
    lib.directives.add(_export(library));
  }
  return lib.build();
}

Directive _export(GeneratedLibrary library) => Directive.export(
      library.originalUri,
      hide: [
        ...library.records.map((it) => it.name),
        ...library.cases.map((it) => it.name),
      ],
    );

Iterable<Directive> _imports(GeneratedLibrary library) => [
      'package:typedefx/typedefx.dart',
      ..._dependencies(library),
    ]
        .toSet()
        .where((uri) => uri != library.originalUri)
        .map((uri) => Directive.import(uri));

Iterable<String> _dependencies(GeneratedLibrary library) => [
      for (final type in library.records) ...[
        ...type.fields.map((it) => it.type.uri),
        ...type.typeParameters.map((it) => it.bound?.uri)
      ],
      for (final type in library.cases) ...[
        ...type.cases.map((it) => it.type.uri),
        ...type.commonFields.map((it) => it.type.uri),
        ...type.typeParameters.map((it) => it.bound?.uri),
      ]
    ].whereType<String>().where((uri) => uri != library.uri);
