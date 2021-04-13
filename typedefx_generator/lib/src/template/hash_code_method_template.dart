import 'package:code_builder/code_builder.dart';

Method inflate({required Iterable<String> fieldNames}) {
  final method = MethodBuilder()
    ..name = 'hashCode'
    ..returns = refer('int')
    ..lambda = true
    ..type = MethodType.getter
    ..annotations.add(refer('override'))
    ..body = _bodyCode(fieldNames);
  return method.build();
}

Code _bodyCode(Iterable<String> fieldNames) => Code([
      'runtimeType.hashCode',
      ...fieldNames.map(
        (it) => 'const DeepCollectionEquality().hash($it)',
      ),
      'super.hashCode',
    ].join('^'));
