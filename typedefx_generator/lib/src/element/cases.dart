import 'package:typedefx_generator/src/element/common.dart';
import 'package:typedefx_generator/src/element/record.dart';

class CasesElement extends TypedefxElement<CaseElement> {
  CasesElement({
    required String name,
    required Iterable<TypeParameterElement> typeParameters,
    required Iterable<CaseElement> parameters,
  }) : super(
          name: name,
          typeParameters: typeParameters,
          parameters: parameters,
        );
}

class CaseElement extends ParameterElement<CaseTypeElement> {
  CaseElement({
    required String name,
    required CaseTypeElement type,
  }) : super(name: name, type: type);
}

class CaseTypeElement = DependentElement with Type;

abstract class TypedefxCaseTypeElement<T extends TypedefxElement>
    extends CaseTypeElement {
  final T element;

  TypedefxCaseTypeElement({
    required String source,
    required Uri? uri,
    required bool isTypedefxElement,
    required bool isNullable,
    required this.element,
  }) : super(
          source: source,
          uri: uri,
          doesRepresentTypedefxElement: isTypedefxElement,
          isNullable: isNullable,
        );
}

class RecordCaseTypeElement = TypedefxCaseTypeElement<RecordElement>
    with Type;

class CasesCaseTypeElement = TypedefxCaseTypeElement<CasesElement>
    with Type;

// class CompositeCaseTypeElement = TypedefxCaseTypeElement<RecordElement>
//     with Type;
