import 'package:typedefx_generator/src/model/common.dart';
import 'package:typedefx_generator/src/model/record.dart';

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
