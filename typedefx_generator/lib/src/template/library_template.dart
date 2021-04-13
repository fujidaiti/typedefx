import 'package:code_builder/code_builder.dart';
import 'package:typedefx_generator/src/models.dart';
import 'package:typedefx_generator/src/template/record_class_template.dart'
    as recordClass;
import 'package:typedefx_generator/src/template/cases_class_template.dart'
    as casesClass;

Library inflate(TLibrary library) {
  final lib = LibraryBuilder()..directives.addAll(_imports(library));
  library.types.forEach((type) {
    lib.body.addAll(_elements(type));
  });
  if (library.exportOriginalUri) {
    lib.directives.add(_export(library));
  }
  return lib.build();
}

Iterable<Spec> _elements(TType type) {
  if (type is RecordType)
    return [recordClass.inflate(type)];
  else if (type is CasesType) return casesClass.inflate(type);
  throw Exception('should not be reached');
}

Directive _export(TLibrary library) => Directive.export(
      library.originalUri,
      hide: library.types.map((it) => it.name).toList(),
    );

Iterable<Directive> _imports(TLibrary library) => [
      'package:typedefx/typedefx.dart',
      ..._dependencies(library),
    ]
        .toSet()
        .where((uri) => uri != library.originalUri)
        .map((uri) => Directive.import(uri));

Iterable<String> _dependencies(TLibrary library) => [
      for (final type in library.types) ...[
        ...type.fields.map((it) => it.type.uri),
        ...type.typeParameters.map((it) => it.bound?.uri)
      ],
    ].whereType<String>().where((uri) => uri != library.uri);
