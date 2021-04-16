class DependentElement {
  final String source;
  final Uri? uri;
  final bool doesRepresentTypedefxElement;
  final bool isNullable;

  DependentElement({
    required this.source,
    required this.uri,
    required this.doesRepresentTypedefxElement,
    required this.isNullable,
  });
}

abstract class TypedefxElement<P extends ParameterElement> {
  final String name;
  final Iterable<TypeParameterElement> typeParameters;
  final Iterable<P> parameters;

  TypedefxElement({
    required this.name,
    required this.typeParameters,
    required this.parameters,
  });
}

abstract class ParameterElement<T extends DependentElement> {
  final String name;
  final T type;

  ParameterElement({
    required this.name,
    required this.type,
  });
}

class TypeParameterElement {
  final String name;
  final DependentElement? bound;

  TypeParameterElement({
    required this.name,
    required this.bound,
  });
}
