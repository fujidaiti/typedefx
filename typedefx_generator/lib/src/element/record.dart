import 'package:typedefx_generator/src/element/common.dart';

class RecordElement extends TypedefxElement<RecordFieldElement> {
  RecordElement({
    required String name,
    required Iterable<TypeParameterElement> typeParameters,
    required Iterable<RecordFieldElement> parameters,
  }) : super(
          name: name,
          typeParameters: typeParameters,
          parameters: parameters,
        );
}

class RecordFieldElement<T extends RecordFieldTypeElement>
    extends ParameterElement<T> {
  final bool isNamed;
  final bool isMandatory;

  RecordFieldElement({
    required String name,
    required T type,
    required this.isNamed,
    required this.isMandatory,
  }) : super(name: name, type: type);
}

class RecordFieldTypeElement = DependentElement with Type;

class RecordSpreadFieldElement
    extends RecordFieldElement<RecordSpreadFieldTypeElement> {
  RecordSpreadFieldElement({
    required String name,
    required bool isNamed,
    required bool isMandatory,
    required RecordSpreadFieldTypeElement type,
  }) : super(
          name: name,
          type: type,
          isNamed: isNamed,
          isMandatory: isMandatory,
        );
}

class RecordSpreadFieldTypeElement extends RecordFieldTypeElement {
  final RecordElement element;

  RecordSpreadFieldTypeElement({
    required String source,
    required Uri? uri,
    required bool doesRepresentTypedefxElement,
    required bool isNullable,
    required this.element,
  }) : super(
          source: source,
          uri: uri,
          doesRepresentTypedefxElement: doesRepresentTypedefxElement,
          isNullable: isNullable,
        );
}

class RecordOmitFieldElement
    extends RecordFieldElement<RecordOmitFieldTypeElement> {
  RecordOmitFieldElement({
    required String name,
    required bool isNamed,
    required bool isMandatory,
  }) : super(
          name: name,
          type: RecordOmitFieldTypeElement(),
          isNamed: isNamed,
          isMandatory: isMandatory,
        );
}

class RecordOmitFieldTypeElement extends RecordFieldTypeElement {
  RecordOmitFieldTypeElement()
      : super(
          source: 'dynamic',
          uri: null,
          doesRepresentTypedefxElement: false,
          isNullable: false,
        );
}
