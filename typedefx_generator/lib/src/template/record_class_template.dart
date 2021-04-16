import 'package:typedefx_generator/src/model/record.dart';
import 'package:typedefx_generator/src/model/common.dart';
import 'package:typedefx_generator/src/template/class_template.dart';
import 'package:typedefx_generator/src/template/equals_method_template.dart';
import 'package:typedefx_generator/src/template/hash_code_method_template.dart';
import 'package:typedefx_generator/src/template/to_string_method_template.dart';

class RecordClassTemplate extends ClassTemplate {
  @override
  final RecordType model;

  RecordClassTemplate(this.model);

  HashCodeMethodTemplate get hashCodeMethod =>
      HashCodeMethodTemplate(fields: model.fields.map((it) => it.name));

  EqualsMethodTemplate get equalsMethod => EqualsMethodTemplate(
        className: parameterizedClassName,
        fields: model.fields.map((it) => it.name),
      );

  ToStringMethodTemplate get toStringMethod => ToStringMethodTemplate(
        label: className,
        fields: model.fields.map((it) => it.name),
      );

  _CopyWithMethodTemplate get copyWithMethod =>
      _CopyWithMethodTemplate(this);

  String get _constructor {
    final params = model.fields.map((it) => 'this.${it.name}');
    return '$className(${params.join(', ')});';
  }

  String get _fields {
    return model.fields
        .map((it) => 'final ${it.type.name} ${it.name};')
        .join('\n\n');
  }

  @override
  String toString() {
    return '''
class $canonicalClassName {
  $_fields

  $_constructor

  $equalsMethod

  $hashCodeMethod

  $toStringMethod

  $copyWithMethod
}
    ''';
  }
}

class _CopyWithMethodTemplate {
  final RecordClassTemplate _class;

  _CopyWithMethodTemplate(this._class);

  String get _returnType => _class.parameterizedClassName;

  String _parameter(TypeField field) => field.type.isNullable
      ? '${field.type.name} ${field.name}'
      : '${field.type.name}? ${field.name}';

  String get _parameters => _class.model.fields.map(_parameter).join(', ');

  String _ctorArgument(TypeField field) =>
      '${field.name} ?? this.${field.name}';

  String get _ctorArguments =>
      _class.model.fields.map(_ctorArgument).join(', ');

  String get _ctor => _class.className;

  String get _ctorCall => '$_ctor($_ctorArguments)';

  @override
  String toString() {
    return '''
  $_returnType copyWith({$_parameters}) => $_ctorCall;
    ''';
  }
}
