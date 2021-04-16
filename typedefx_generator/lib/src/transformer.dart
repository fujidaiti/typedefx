import 'package:typedefx_generator/src/config.dart';
import 'package:typedefx_generator/src/utils.dart';
import 'package:typedefx_generator/src/element/target_library.dart';
import 'package:typedefx_generator/src/element/record.dart';
import 'package:typedefx_generator/src/element/cases.dart';
import 'package:typedefx_generator/src/element/common.dart';
import 'package:typedefx_generator/src/model/common.dart';
import 'package:typedefx_generator/src/model/generated_library.dart';
import 'package:typedefx_generator/src/model/record.dart';
import 'package:typedefx_generator/src/model/cases.dart';
import 'package:typedefx_generator/src/model/composite.dart';

GeneratedLibrary transform(TargetLibraryElement library) =>
    GeneratedLibrary(
      records: library.elements.whereType<RecordElement>().map(_record),
      cases: library.elements.whereType<CasesElement>().map(_cases),
      composites: [],
      uri: _generatedFileUri(library.uri),
      originalUri: library.uri.toString(),
      exportOriginalUri:
          _shouldExportOriginalUriFromGeneratedFile(library),
    );

RecordType _record(RecordElement element) => RecordType(
      name: element.name,
      typeParameters: _typeParameters(element.typeParameters),
      fields: _recordFields(element.parameters),
    );

Iterable<TypeField> _recordFields(Iterable<RecordFieldElement> elements) {
  final fields = <String, TypeField>{};
  final omittedFields = <String>[];
  elements.forEach((element) {
    if (element is RecordSpreadFieldElement) {
      _spreadRrecord(
        _record(element.type.element),
        element.isNamed,
        element.isMandatory,
      ).forEach((field) => fields[field.name] = field);
    } else if (element is RecordOmitFieldElement) {
      omittedFields.add(element.name);
    } else {
      final field = _recordField(element);
      fields[field.name] = field;
    }
  });
  omittedFields.forEach((field) => fields.remove(field));
  return fields.values;
}

Iterable<TypeField> _spreadRrecord(
  RecordType record,
  bool isNamed,
  bool isMandatory,
) =>
    record.fields.map(
      (field) => TypeField(
        name: field.name,
        type: field.type,
        isMandatory: isMandatory,
        isNamed: isNamed,
      ),
    );

TypeField _recordField(
  RecordFieldElement element,
) =>
    TypeField(
      name: element.name,
      type: ConcreteType(
        name: element.type.source,
        uri: _dependencyUri(element.type),
        isNullable: element.type.isNullable,
      ),
      isMandatory: element.isMandatory,
      isNamed: element.isNamed,
    );

CasesType _cases(CasesElement element) => CasesType(
      name: element.name,
      typeParameters: _typeParameters(element.typeParameters),
      cases: element.parameters.map(_case),
      commonFields: [],
    );

Case _case(CaseElement element) => Case(
      name: element.name,
      type: CaseType(
        name: element.type.source,
        uri: _dependencyUri(element.type),
        isNullable: element.type.isNullable,
        source: () {
          final type = element.type;
          if (type is RecordCaseTypeElement) return _record(type.element);
          if (type is CasesCaseTypeElement) return _cases(type.element);
          return null;
        }(),
      ),
    );

Iterable<TypeParameter> _typeParameters(
        Iterable<TypeParameterElement> elements) =>
    elements.map(
      (it) => TypeParameter(
        name: it.name,
        bound: it.bound?.let(
          (bound) => ConcreteType(
            name: bound.source,
            uri: _dependencyUri(bound),
            isNullable: bound.isNullable,
          ),
        ),
      ),
    );

bool _shouldExportOriginalUriFromGeneratedFile(
        TargetLibraryElement library) =>
    library.imports
        .any((it) => it == 'package:typedefx/typedefx_export.dart');

String? _dependencyUri(DependentElement dependency) {
  final uri = dependency.uri;
  if (uri == null) return null;
  if (_isCoreLibrary(uri)) return null;
  if (dependency.doesRepresentTypedefxElement) return _generatedFileUri(uri);
  return uri.toString();
}

bool _isCoreLibrary(Uri uri) => uri.toString().startsWith('dart:core');

String _generatedFileUri(Uri uri) =>
    uri.toString().replaceFirst('.dart', generated_file_extension);
