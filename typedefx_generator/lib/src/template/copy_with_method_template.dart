import 'package:code_builder/code_builder.dart';
import 'package:typedefx_generator/src/model/record.dart';
import 'package:typedefx_generator/src/model/common.dart';

Method inflate(RecordType type) {
  final method = MethodBuilder()
    ..name = 'copyWith'
    ..returns = refer(_returnType(type))
    ..optionalParameters.addAll(_parameters(type))
    ..lambda = true
    ..body = _bodyCode(type);
  return method.build();
}

Iterable<Parameter> _parameters(RecordType type) =>
    type.fields.map(_parameter);

Parameter _parameter(TypeField field) {
  final param = ParameterBuilder()
    ..name = field.name
    ..type = refer(_nullableType(field))
    ..named = true;
  return param.build();
}

String _returnType(RecordType type) {
  final params = type.typeParameters.map((it) => it.name);
  return params.isNotEmpty
      ? '${type.name}<${params.join(', ')}>'
      : type.name;
}

String _nullableType(TypeField field) {
  final type = field.type.name.trim();
  return type.endsWith('?') ? type : '$type?';
}

Code _bodyCode(RecordType type) {
  final ctor = '${type.name}';
  final positionalArgs = type.fields
      .where((it) => !it.isNamed)
      .map((it) => '${it.name} ?? this.${it.name}');
  final namedArgs = type.fields
      .where((it) => it.isNamed)
      .map((it) => '${it.name}: ${it.name} ?? this.${it.name}');
  final args = [
    ...positionalArgs,
    ...namedArgs,
  ].join(', ');
  return Code('$ctor($args)');
}
