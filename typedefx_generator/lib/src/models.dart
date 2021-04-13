class TLibrary {
  final Iterable<TType> types;
  final String uri;
  final String originalUri;
  final bool exportOriginalUri;

  TLibrary({
    required this.types,
    required this.uri,
    required this.originalUri,
    required this.exportOriginalUri,
  });
}

class TType {
  final String name;
  final Iterable<TTypeParameter> typeParameters;
  final Iterable<TTypeField> fields;

  TType({
    required this.name,
    required this.typeParameters,
    required this.fields,
  });
}

class StructType = TType with Type;
class RecordType = TType with Type;
class CompositeType = TType with Type;
class CasesType = TType with Type;

class TTypeField {
  final String name;
  final TSymbol type;
  final TType? typeMeta;
  final bool isMandatory;
  final bool isPositional;
  final bool isNullable;

  TTypeField({
    required this.name,
    required this.type,
    required this.typeMeta,
    required this.isMandatory,
    required this.isPositional,
    required this.isNullable,
  });
}

class TTypeParameter {
  final String name;
  final TSymbol? bound;

  TTypeParameter({
    required this.name,
    this.bound,
  });
}

class TSymbol {
  final String name;
  final String? uri;

  TSymbol({
    required this.name,
    required this.uri,
  });
}
