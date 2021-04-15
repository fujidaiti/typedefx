import 'package:analyzer/dart/element/element.dart' as E;
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:typedefx/typedefx.dart';
import 'package:typedefx_generator/src/utils.dart';
import 'package:typedefx_generator/src/valid_elements.dart';

const _TypedefxChecker = const TypeChecker.fromRuntime(Typedefx);
const _RecordChecker = const TypeChecker.fromRuntime(Record);
const _CasesChecker = const TypeChecker.fromRuntime(Cases);
const _SpreadChecker = const TypeChecker.fromRuntime(Spread);
const _OmitChecker = const TypeChecker.fromRuntime(Omit);

final _cachedRecordElements = <int, RecordElement>{};
final _cachedCasesElements = <int, CasesElement>{};

TargetLibraryElement parse(
  LibraryReader library,
) =>
    TargetLibraryElement(
      imports:
          library.element.imports.map((it) => it.uri).whereType<String>(),
      uri: library.element.source.uri,
      elements: library.allElements
          .whereType<E.TypeAliasElement>()
          .map(_tryParseTypeAlias)
          .whereType<TypedefxElement>(),
    );

TypedefxElement? _tryParseTypeAlias(E.TypeAliasElement element) {
  if (_TypedefxChecker.hasAnnotationOf(element))
    return _parseTypeAlias(element);
  return null;
}

TypedefxElement _parseTypeAlias(E.TypeAliasElement element) {
  final bool isRecord = _RecordChecker.hasAnnotationOf(element);
  final bool isCases = _CasesChecker.hasAnnotationOf(element);
  if (isRecord && isCases) {
    throw InvalidGenerationSourceError(
      "Can't use @record and @cases, @composite at the same time",
      element: element,
    );
  }
  return [
    when(isRecord, then: () => _parseRecordElement(element)),
    when(isCases, then: () => _parseCasesElement(element)),
  ].eval();
}

RecordElement _parseRecordElement(E.TypeAliasElement element) {
  return RecordElement(
    name: _aliasName(element),
    typeParameters: _aliasTypeParameters(element),
    parameters: _parseRecordFields(element),
  );
}

Iterable<RecordFieldElement> _parseRecordFields(
        E.TypeAliasElement element) =>
    _typeAliasParameters(element).map(_parseRecordField);

RecordFieldElement _parseRecordField(E.ParameterElement parameter) {
  final isMarkedAsOmit = _OmitChecker.hasAnnotationOf(parameter);
  final isMarkedAsSpread = _SpreadChecker.hasAnnotationOf(parameter);
  if (isMarkedAsOmit && isMarkedAsSpread) {
    throw InvalidGenerationSourceError(
      "@spread and @omit can't be used at the same time",
      element: parameter,
    );
  }
  return [
    when(isMarkedAsSpread, then: () => _parseRecordSpreadField(parameter)),
    when(isMarkedAsOmit, then: () => _parseRecordOmitField(parameter)),
    when(true, then: () => _parseRecorField(parameter)),
  ].eval();
}

RecordSpreadFieldElement _parseRecordSpreadField(
    E.ParameterElement parameter) {
  final record = _tryParseType(parameter.type);
  if (record is! RecordElement) {
    throw InvalidGenerationSourceError(
      "@spread can only be used for an @record parameter",
      element: parameter,
    );
  }
  return RecordSpreadFieldElement(
    name: parameter.name,
    isMandatory: _isMandatoryParameter(parameter),
    isNamed: parameter.isNamed,
    type: RecordSpreadFieldTypeElement(
      element: record,
      source: _parameterTypeSource(parameter),
      uri: _uri(parameter.type),
      isTypedefxElement: _isTypedefxElement(parameter.type),
      isNullable: _typeNullability(parameter.type),
    ),
  );
}

RecordOmitFieldElement _parseRecordOmitField(
    E.ParameterElement parameter) {
  return RecordOmitFieldElement(
    name: parameter.name,
    isMandatory: _isMandatoryParameter(parameter),
    isNamed: parameter.isNamed,
  );
}

RecordFieldElement _parseRecorField(E.ParameterElement parameter) {
  return RecordFieldElement(
    name: parameter.name,
    type: RecordFieldTypeElement(
      source: _parameterTypeSource(parameter),
      isNullable: _typeNullability(parameter.type),
      uri: _uri(parameter.type),
      isTypedefxElement: _isTypedefxElement(parameter.type),
    ),
    isNamed: parameter.isNamed,
    isMandatory: _isMandatoryParameter(parameter),
  );
}

bool _typeNullability(DartType type) =>
    type.nullabilitySuffix == NullabilitySuffix.question;

bool _isMandatoryParameter(E.ParameterElement parameter) =>
    parameter.isRequiredPositional ||
    parameter.isRequiredNamed ||
    (parameter.isNamed && _typeNullability(parameter.type));

CasesElement _parseCasesElement(E.TypeAliasElement typeAlias) =>
    CasesElement(
      name: typeAlias.name,
      typeParameters: _aliasTypeParameters(typeAlias),
      parameters: _typeAliasParameters(typeAlias).map(_parseCase),
    );

CaseElement _parseCase(E.ParameterElement parameter) {
  return CaseElement(
    name: parameter.name,
    type: _parseCaseType(parameter),
  );
}

CaseTypeElement _parseCaseType(E.ParameterElement parameter) {
  final source = _parameterTypeSource(parameter);
  final uri = _uri(parameter.type);
  final isTypedefxElement = _isTypedefxElement(parameter.type);
  final typedefxElement = _tryParseType(parameter.type);
  final isNullable = _typeNullability(parameter.type);
  if (typedefxElement is RecordElement)
    return RecordCaseTypeElement(
      element: typedefxElement,
      source: source,
      isTypedefxElement: isTypedefxElement,
      uri: uri,
      isNullable: isNullable,
    );
  else if (typedefxElement is CasesElement)
    return CasesCaseTypeElement(
      element: typedefxElement,
      source: source,
      isTypedefxElement: isTypedefxElement,
      uri: uri,
      isNullable: isNullable,
    );
  else
    return CaseTypeElement(
      source: source,
      isTypedefxElement: isTypedefxElement,
      uri: uri,
      isNullable: isNullable,
    );
}

E.TypeAliasElement? _toTypeAliasElementOrNull(DartType type) {
  final element = type.element;
  if (element == null) return null;
  if (element is E.TypeAliasElement) return element;
  final enclosed = element.enclosingElement;
  if (enclosed is E.TypeAliasElement) return enclosed;
  return null;
}

TypedefxElement? _tryParseType(DartType type) =>
    _toTypeAliasElementOrNull(type)?.let(_tryParseTypeAlias);

String _aliasName(E.TypeAliasElement element) => element.name;

Iterable<TypeParameterElement> _aliasTypeParameters(
  E.TypeAliasElement element,
) =>
    element.typeParameters.map(
      (param) => TypeParameterElement(
        name: param.name,
        bound: param.bound?.let(
          (bound) => TypeParameterBoundElement(
            name: bound.toString(),
            isTypedefxElement: _isTypedefxElement(bound),
            uri: _uri(bound),
            isNullable: _typeNullability(bound),
          ),
        ),
      ),
    );

Uri? _uri(DartType type) => type.element?.source?.uri;

bool _isTypedefxElement(DartType type) =>
    _toTypeAliasElementOrNull(type) != null;

String _parameterTypeSource(E.ParameterElement parameter) {
  final source = _toTypeAliasElementOrNull(parameter.type)?.let(
    (alias) {
      final src = parameter.source!.contents.data;
      final pattern = alias.name + r'\s*(<.+>)?\s*\??\s*$';
      return RegExp(pattern)
          .firstMatch(src.substring(0, parameter.nameOffset))
          ?.group(0)
          ?.trim();
    },
  );
  return source ?? parameter.type.toString();
}

Iterable<E.ParameterElement> _typeAliasParameters(
        E.TypeAliasElement alias) =>
    (alias.aliasedElement as E.GenericFunctionTypeElement).parameters;
