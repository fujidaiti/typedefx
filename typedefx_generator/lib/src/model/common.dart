abstract class TypedefxType {
  final String name;
  final Iterable<TypeParameter> typeParameters;

  TypedefxType({
    required this.name,
    required this.typeParameters,
  });
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

  bool get isUnnamedMandatory => !isNamed && isMandatory;
}

class TypeParameter {
  final String name;
  final ConcreteType? bound;

  TypeParameter({
    required this.name,
    required this.bound,
  });
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

  String get nameWithNullabilitySuffix => isNullable ? '$name?' : name;

  String get nullableName => '$name?';
}
