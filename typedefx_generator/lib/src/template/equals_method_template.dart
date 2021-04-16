// https://github.com/rrousselGit/freezed/blob/59f5473225c9d127abb730a69fab17fecdc89afb/packages/freezed/lib/src/templates/concrete_template.dart#L338

import 'package:code_builder/code_builder.dart';

class EqualsMethodTemplate {
  final String className;
  final Iterable<String> fields;

  EqualsMethodTemplate({
    required this.className,
    required this.fields,
  });

  String _identical(String field) => 'identical(other.$field, $field)';

  String _deepCollectionEquality(String field) =>
      'const DeepCollectionEquality().equals(other.$field, $field)';

  String _fieldEquality(String field) =>
      '(${_identical(field)} || ${_deepCollectionEquality(field)})';

  String get _fieldEqualities =>
      fields.map(_fieldEquality).join(' && \n');

  @override
  String toString() {
    return '''
  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is $className && $_fieldEqualities);
  }
    ''';
  }
}

Method inflate({
  required String className,
  required Iterable<String> fieldNames,
}) {
  final method = MethodBuilder()
    ..name = 'operator =='
    ..returns = refer('bool')
    ..requiredParameters.add(_parameter())
    ..annotations.add(refer('override'))
    ..body = _bodyCode(className, fieldNames);
  return method.build();
}

Parameter _parameter() => Parameter(
      (param) => param
        ..name = 'other'
        ..type = refer('dynamic'),
    );

Code _bodyCode(String className, Iterable<String> fieldNames) {
  final details = [
    'other is $className',
    ...fieldNames.map((name) {
      return '''
    (identical(other.$name, $name) ||
                const DeepCollectionEquality().equals(other.$name, $name))
    ''';
    }),
  ].join(' && ');
  return Code('return identical(this, other) || ($details);');
}
