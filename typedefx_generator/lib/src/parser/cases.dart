import 'package:analyzer/dart/element/element.dart' as E;
import 'package:typedefx_generator/src/element/record.dart';
import 'package:typedefx_generator/src/element/cases.dart';
import 'package:typedefx_generator/src/parser/common.dart';
import 'package:typedefx_generator/src/parser/target_library.dart';
import 'package:typedefx_generator/src/parser/type_alias.dart';

CasesElement parse(E.TypeAliasElement typeAlias) => CasesElement(
      name: typeAlias.name,
      typeParameters: typeParameters(typeAlias),
      parameters: typeAlias.parameters().map(_parseCase),
    );

CaseElement _parseCase(E.ParameterElement parameter) {
  return CaseElement(
    name: parameter.name,
    type: _parseCaseType(parameter),
  );
}

CaseTypeElement _parseCaseType(E.ParameterElement parameter) {
  final source = parameter.typeSource();
  final uri = parameter.type.uri();
  final isTypedefxElement = parameter.type.doesRepresentTypedefxElement();
  final typedefxElement = tryParseDependentType(parameter.type);
  final isNullable = parameter.type.isNullable();
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
      doesRepresentTypedefxElement: isTypedefxElement,
      uri: uri,
      isNullable: isNullable,
    );
}
