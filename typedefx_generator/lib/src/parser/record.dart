import 'package:analyzer/dart/element/element.dart' as E;
import 'package:source_gen/source_gen.dart';
import 'package:typedefx_generator/src/element/record.dart';
import 'package:typedefx_generator/src/parser/common.dart';
import 'package:typedefx_generator/src/parser/target_library.dart';
import 'package:typedefx_generator/src/parser/type_alias.dart';

RecordElement parse(E.TypeAliasElement element) {
  return RecordElement(
    name: element.name,
    typeParameters: typeParameters(element),
    parameters: _parseFields(element),
  );
}

Iterable<RecordFieldElement> _parseFields(E.TypeAliasElement typeAlias) =>
    typeAlias.parameters().map(_parseField);

RecordFieldElement _parseField(E.ParameterElement parameter) {
  if (_isNonnullableUnnamedOptionalParameter(parameter)) {
    throw InvalidGenerationSourceError(
      "A non-nullable, unnnamed optional parameter is not allowed",
      element: parameter,
    );
  }
  final isMarkedAsOmit = OmitChecker.hasAnnotationOf(parameter);
  final isMarkedAsSpread = SpreadChecker.hasAnnotationOf(parameter);
  if (isMarkedAsOmit && isMarkedAsSpread) {
    throw InvalidGenerationSourceError(
      "@spread and @omit can't be used at the same time",
      element: parameter,
    );
  }
  if (isMarkedAsSpread) return _parseRecordSpreadField(parameter);
  if (isMarkedAsOmit) return _parseRecordOmitField(parameter);
  return _parseRecorField(parameter);
}

RecordSpreadFieldElement _parseRecordSpreadField(
    E.ParameterElement parameter) {
  final record = tryParseDependentType(parameter.type);
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
      source: parameter.typeSource(),
      uri: parameter.type.uri(),
      isTypedefxElement: parameter.type.doesRepresentTypedefxElement(),
      isNullable: parameter.type.isNullable(),
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
      source: parameter.typeSource(),
      uri: parameter.type.uri(),
      isTypedefxElement: parameter.type.doesRepresentTypedefxElement(),
      isNullable: parameter.type.isNullable(),
    ),
    isNamed: parameter.isNamed,
    isMandatory: _isMandatoryParameter(parameter),
  );
}

bool _isMandatoryParameter(E.ParameterElement parameter) =>
    parameter.isRequiredPositional ||
    parameter.isRequiredNamed ||
    (parameter.isNamed && parameter.type.isNullable());

bool _isNonnullableUnnamedOptionalParameter(
        E.ParameterElement parameter) =>
    !parameter.type.isNullable() &&
    !parameter.isNamed &&
    !_isMandatoryParameter(parameter);
