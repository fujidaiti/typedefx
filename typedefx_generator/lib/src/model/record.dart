import 'package:typedefx_generator/src/model/common.dart';

class RecordType extends TypedefxType {
  final Iterable<TypeField> fields;

  RecordType({
    required String name,
    required Iterable<TypeParameter> typeParameters,
    required this.fields,
  }) : super(name: name, typeParameters: typeParameters);
}
