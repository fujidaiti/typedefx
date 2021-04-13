import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:typedefx/typedefx.dart';
import 'package:typedefx_generator/src/config.dart';
import 'package:typedefx_generator/src/models.dart';

TLibrary parse(LibraryReader library) => TLibrary(
      uri: _generatedFileUri(library.element.source.uri),
      originalUri: library.element.source.uri.toString(),
      exportOriginalUri:
          _shouldExportOriginalUriFromGeneratedFile(library),
      types: library.allElements.map(_type).whereType<TType>(),
    );

TType? _type(Element element) {
  final alias = _resolveAlias(element);
  if (alias == null) return null;
  if (_hasStructAnnotation(element)) return _structType(alias);
  if (_hasRecordAnnotation(element)) return _recordType(alias);
  if (_hasCompositeAnnotation(element)) return _compositeType(alias);
  if (_hasUnionAnnotation(element)) return _casesType(alias);
  return null;
}

StructType _structType(TypeAliasElement element) => StructType(
      name: _recordTypeName(element),
      typeParameters: _recordTypeParameters(element),
      fields: _recordFields(element),
    );

RecordType _recordType(TypeAliasElement element) => RecordType(
      name: _recordTypeName(element),
      typeParameters: _recordTypeParameters(element),
      fields: _recordFields(element),
    );

CasesType _casesType(TypeAliasElement element) => CasesType(
      name: _recordTypeName(element),
      typeParameters: _recordTypeParameters(element),
      fields: _recordFields(element),
    );

CompositeType _compositeType(TypeAliasElement element) => CompositeType(
      name: _recordTypeName(element),
      typeParameters: _recordTypeParameters(element),
      fields: _recordFields(element),
    );

String _recordTypeName(TypeAliasElement element) => element.name;

Iterable<TTypeParameter> _recordTypeParameters(TypeAliasElement element) =>
    element.typeParameters.map(_recordTypeParameter);

TTypeParameter _recordTypeParameter(TypeParameterElement parameter) =>
    TTypeParameter(
      name: parameter.name,
      bound: _recordTypeParameterBound(parameter),
    );

TSymbol? _recordTypeParameterBound(TypeParameterElement parameter) {
  final DartType? bound = parameter.bound;
  return bound != null
      ? TSymbol(
          name: bound.toString(),
          uri: _recordTypeParameterBoundUri(parameter),
        )
      : null;
}

String? _recordTypeParameterBoundUri(TypeParameterElement parameter) {
  final boundElement = parameter.bound?.element;
  return boundElement != null ? _resolvedUri(boundElement) : null;
}

Iterable<TTypeField> _recordFields(TypeAliasElement element) {
  final fun = element.aliasedElement! as GenericFunctionTypeElement;
  return fun.parameters.map(_recordField);
}

TTypeField _recordField(ParameterElement element) => TTypeField(
      name: _recordFieldName(element),
      type: _recordFieldType(element),
      typeMeta: _typedefParameterTypeMeta(element),
      isMandatory: _recordFieldIsMandatory(element),
      isPositional: _recordFieldIsPositional(element),
      isNullable: _typedefParameterNullability(element),
    );

TType? _typedefParameterTypeMeta(ParameterElement element) {
  final typeElement = element.type.element;
  if (typeElement != null) return _type(typeElement);
  return null;
}

bool _typedefParameterNullability(ParameterElement element) =>
    element.type.nullabilitySuffix == NullabilitySuffix.question;

String _recordFieldName(ParameterElement element) => element.name;

String? _recordFieldTypeUri(ParameterElement element) {
  final Element? typeElement = element.type.element;
  return typeElement != null ? _resolvedUri(typeElement) : null;
}

TSymbol _recordFieldType(ParameterElement element) => TSymbol(
      name: _recordFieldTypeSource(element),
      uri: _recordFieldTypeUri(element),
    );

String _recordFieldTypeSource(ParameterElement element) {
  final type = element.type;
  final typeElement = type.element;
  final alias = typeElement != null ? _resolveAlias(typeElement) : null;
  if (alias != null) {
    final source = element.source!.contents.data;
    final pattern = alias.name + r'\s*(<.+>)?\s*\??\s*$';
    final match = RegExp(pattern)
        .firstMatch(source.substring(0, element.nameOffset))
        ?.group(0)
        ?.trim();
    if (match != null) return match;
  }
  return type.toString();
}

bool _isFunctionTypeAlias(Element? element) =>
    element != null && _resolveAlias(element) != null;

TypeAliasElement? _resolveAlias(Element element) {
  if (element is TypeAliasElement) return element;
  final enclosingElement = element.enclosingElement;
  if (enclosingElement is TypeAliasElement) return enclosingElement;
  return null;
}

bool _recordFieldIsPositional(ParameterElement element) =>
    element.isPositional;

bool _recordFieldIsMandatory(ParameterElement element) =>
    element.isRequiredPositional ||
    element.isRequiredNamed ||
    (element.isNamed && !_isNullableType(element.type));

bool _isNullableType(DartType type) =>
    type.nullabilitySuffix == NullabilitySuffix.question;

String? _resolvedUri(Element element) {
  if (element is TypeParameterElement) return null;
  final uri = element.source?.uri;
  if (uri == null) return null;
  if (_isCoreLibrary(uri)) return null;
  return _isRecordElement(element)
      ? _generatedFileUri(uri)
      : uri.toString();
}

bool _isCoreLibrary(Uri uri) => uri.toString().startsWith('dart:core');

bool _isRecordElement(Element element) {
  final alias = _resolveAlias(element);
  if (alias == null) return false;
  return _hasRecordAnnotation(element);
}

String _generatedFileUri(Uri uri) =>
    uri.toString().replaceFirst('.dart', generated_file_extension);

bool _hasStructAnnotation(Element element) =>
    const TypeChecker.fromRuntime(Struct).hasAnnotationOf(element);

bool _hasRecordAnnotation(Element element) =>
    const TypeChecker.fromRuntime(Record).hasAnnotationOf(element);

bool _hasUnionAnnotation(Element element) =>
    const TypeChecker.fromRuntime(Cases).hasAnnotationOf(element);

bool _hasCompositeAnnotation(Element element) =>
    const TypeChecker.fromRuntime(Composite).hasAnnotationOf(element);

bool _shouldExportOriginalUriFromGeneratedFile(LibraryReader library) =>
    library.element.imports
        .any((it) => it.uri == 'package:typedefx/typedefx_export.dart');
