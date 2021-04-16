import 'package:typedefx_generator/src/model/generated_library.dart';
import 'package:typedefx_generator/src/template/record_class_template.dart';
import 'package:typedefx_generator/src/template/cases_class_template.dart';

class LibraryTemplate {
  final GeneratedLibrary library;

  LibraryTemplate(this.library);

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

  String get _imports => [
        'package:typedefx/typedefx.dart',
        ..._dependencies(library),
      ]
          .toSet()
          .where((uri) => uri != library.originalUri)
          .map((it) => "import '$it';")
          .join('\n');

  String get _export {
    final hide = [
      ...library.records.map((it) => it.name),
      ...library.cases.map((it) => it.name),
    ].join(', ');
    return "export '${library.originalUri}' hide $hide;";
  }

  String get recordClasses =>
      library.records.map((it) => RecordClassTemplate(it)).join('\n\n');

  String get casesClasses =>
      library.cases.map((it) => CasesClassTemplate(it)).join('\n\n');

  @override
  String toString() {
    return '''
    $_imports

    ${library.exportOriginalUri ? _export : ''}

    $recordClasses

    $casesClasses
    ''';
  }
}
