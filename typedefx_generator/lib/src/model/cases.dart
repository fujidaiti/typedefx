import 'package:typedefx_generator/src/model/common.dart';
import 'package:typedefx_generator/src/model/record.dart';

class CasesType extends TypedefxType {
  final Iterable<Case> cases;

  CasesType({
    required String name,
    required Iterable<TypeParameter> typeParameters,
    required this.cases,
  }) : super(name: name, typeParameters: typeParameters);

  Iterable<TypeField> get commonFields => _intersection(
        cases.map((it) {
          if (it is RecordCase) return it.typeSpec.fields;
          if (it is CasesCase) return it.typeSpec.commonFields;
          return [];
        }),
      );
}

class Case<T> {
  final String name;
  final T typeSpec;
  final ConcreteType type;

  Case({
    required this.name,
    required this.typeSpec,
    required this.type,
  });
}

class AnyCase = Case<Null> with Type;
class RecordCase = Case<RecordType> with Type;
class CasesCase = Case<CasesType> with Type;

Iterable<TypeField> _intersection(
    Iterable<Iterable<TypeField>> fieldLists) {
  if (fieldLists.length < 2) {
    return [];
  } else if (fieldLists.length == 2) {
    final first = fieldLists.first;
    final second = fieldLists.skip(1).first;
    return first.toList()
      ..removeWhere(
        (field) => second.every(
          (it) => it.name != field.name,
        ),
      );
  } else {
    return _intersection([
      fieldLists.first,
      _intersection(fieldLists.skip(1)),
    ]);
  }
}
