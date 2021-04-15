class GeneratedLibrary {
  final Iterable<RecordType> records;
  final Iterable<CasesType> cases;
  final Iterable<CompositeType> composites;
  final String uri;
  final String originalUri;
  final bool exportOriginalUri;

  GeneratedLibrary({
    required this.records,
    required this.cases,
    required this.composites,
    required this.uri,
    required this.originalUri,
    required this.exportOriginalUri,
  });
}

abstract class TypedefxType {
  final String name;
  final Iterable<TypeParameter> typeParameters;

  TypedefxType({
    required this.name,
    required this.typeParameters,
  });
}

class RecordType extends TypedefxType {
  final Iterable<TypeField> fields;

  RecordType({
    required String name,
    required Iterable<TypeParameter> typeParameters,
    required this.fields,
  }) : super(name: name, typeParameters: typeParameters);
}

class TypeField {
  final String name;
  final ConcreteType type;
  final bool isMandatory;
  final bool isNamed;

  TypeField({
    required this.name,
    required this.type,
    required this.isMandatory,
    required this.isNamed,
  });
}

class TypeParameter {
  final String name;
  final ConcreteType? bound;

  TypeParameter({
    required this.name,
    required this.bound,
  });
}

class CasesType extends TypedefxType {
  final Iterable<Case> cases;
  final Iterable<TypeField> commonFields;

  CasesType({
    required String name,
    required Iterable<TypeParameter> typeParameters,
    required this.cases,
    required this.commonFields,
  }) : super(name: name, typeParameters: typeParameters);
}

class Case {
  final String name;
  final CaseType type;

  Case({
    required this.name,
    required this.type,
  });
}

class CaseType extends ConcreteType {
  final TypedefxType? source;

  CaseType({
    required String name,
    required String? uri,
    required bool isNullable,
    required this.source,
  }) : super(
          name: name,
          uri: uri,
          isNullable: isNullable,
        );
}

class CompositeType extends TypedefxType {
  final Iterable<Component> components;

  CompositeType({
    required String name,
    required Iterable<TypeParameter> typeParameters,
    required this.components,
  }) : super(name: name, typeParameters: typeParameters);
}

class Component<T extends TypedefxType> {
  final String name;
  final ComponentType<T> type;

  Component({
    required this.name,
    required this.type,
  });
}

class NestedRecord = Component<RecordType> with Type;
class NestedComposite = Component<CompositeType> with Type;

abstract class ComponentType<T extends TypedefxType> extends ConcreteType {
  final T source;

  ComponentType({
    required String name,
    required String? uri,
    required bool isNullable,
    required this.source,
  }) : super(
          name: name,
          uri: uri,
          isNullable: isNullable,
        );
}

class ConcreteType {
  final String name;
  final String? uri;
  final bool isNullable;

  ConcreteType({
    required this.name,
    required this.uri,
    required this.isNullable,
  });
}

// composite.partial.data
// composite.part.data
