class TargetLibraryElement {
  final Iterable<String> imports;
  final Uri uri;
  final Iterable<TypedefxElement> elements;

  TargetLibraryElement({
    required this.imports,
    required this.uri,
    required this.elements,
  });
}

abstract class DependentElement {
  final Uri? uri;
  final bool isTypedefxElement;
  final bool isNullable;

  DependentElement({
    required this.uri,
    required this.isTypedefxElement,
    required this.isNullable,
  });
}

abstract class TypedefxElement {
  final String name;
  final Iterable<TypeParameterElement> typeParameters;
  abstract final Iterable<ParameterElement> parameters;

  TypedefxElement({
    required this.name,
    required this.typeParameters,
  });
}

abstract class ParameterElement {
  final String name;
  abstract final ParameterTypeElement type;

  ParameterElement({
    required this.name,
  });
}

abstract class ParameterTypeElement extends DependentElement {
  final String source;

  ParameterTypeElement({
    required Uri? uri,
    required bool isTypedefxElement,
    required bool isNullable,
    required this.source,
  }) : super(
          uri: uri,
          isTypedefxElement: isTypedefxElement,
          isNullable: isNullable,
        );
}

class TypeParameterElement {
  final String name;
  final TypeParameterBoundElement? bound;

  TypeParameterElement({
    required this.name,
    required this.bound,
  });
}

class TypeParameterBoundElement extends DependentElement {
  final String name;

  TypeParameterBoundElement({
    required Uri? uri,
    required bool isTypedefxElement,
    required bool isNullable,
    required this.name,
  }) : super(
          uri: uri,
          isTypedefxElement: isTypedefxElement,
          isNullable: isNullable,
        );
}

class RecordElement extends TypedefxElement {
  @override
  final Iterable<RecordFieldElement> parameters;

  RecordElement({
    required String name,
    required Iterable<TypeParameterElement> typeParameters,
    required this.parameters,
  }) : super(name: name, typeParameters: typeParameters);
}

class RecordFieldElement extends ParameterElement {
  @override
  final RecordFieldTypeElement type;

  final bool isNamed;
  final bool isMandatory;

  RecordFieldElement({
    required String name,
    required this.type,
    required this.isNamed,
    required this.isMandatory,
  }) : super(name: name);
}

class RecordFieldTypeElement = ParameterTypeElement with Type;

class RecordSpreadFieldElement extends RecordFieldElement {
  @override
  final RecordSpreadFieldTypeElement type;

  RecordSpreadFieldElement({
    required String name,
    required bool isNamed,
    required bool isMandatory,
    required this.type,
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
    required bool isTypedefxElement,
    required bool isNullable,
    required this.element,
  }) : super(
          source: source,
          uri: uri,
          isTypedefxElement: isTypedefxElement,
          isNullable: isNullable,
        );
}

class RecordOmitFieldElement extends RecordFieldElement {
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
          isTypedefxElement: false,
          isNullable: false,
        );
}

class CasesElement extends TypedefxElement {
  @override
  final Iterable<CaseElement> parameters;

  CasesElement({
    required String name,
    required Iterable<TypeParameterElement> typeParameters,
    required this.parameters,
  }) : super(name: name, typeParameters: typeParameters);
}

class CaseElement extends ParameterElement {
  @override
  final CaseTypeElement type;

  CaseElement({
    required String name,
    required this.type,
  }) : super(name: name);
}

class CaseTypeElement = ParameterTypeElement with Type;

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
          isTypedefxElement: isTypedefxElement,
          isNullable: isNullable,
        );
}

class RecordCaseTypeElement = TypedefxCaseTypeElement<RecordElement>
    with Type;

class CasesCaseTypeElement = TypedefxCaseTypeElement<CasesElement>
    with Type;

// class CompositeCaseTypeElement = TypedefxCaseTypeElement<RecordElement>
//     with Type;
