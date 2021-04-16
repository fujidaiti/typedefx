import 'package:typedefx_generator/src/model/common.dart';

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