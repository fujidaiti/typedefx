import 'package:code_builder/code_builder.dart';

Method inflate({
  required String className,
  required Iterable<String> fieldNames,
}) {
  final method = MethodBuilder()
    ..name = 'toString'
    ..returns = refer('String')
    ..annotations.add(refer('override'))
    ..lambda = true
    ..body = _bodyCode(className, fieldNames);
  return method.build();
}

Code _bodyCode(String className, Iterable<String> fieldNames) {
  final values = fieldNames.map((it) => '$it: \$$it').join(', ');
  return Code("'$className($values)'");
}
