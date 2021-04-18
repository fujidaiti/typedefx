import 'package:typedefx_generator/src/model/record.dart';
import 'package:typedefx_generator/src/model/common.dart';
import 'package:typedefx_generator/src/template/class_template.dart';
import 'package:typedefx_generator/src/template/parameters_template.dart';
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

  _ConstructorTemplate get _constructor => _ConstructorTemplate(this);

  String get _fields {
    return model.fields
        .map((it) =>
            'final ${it.type.nameWithNullabilitySuffix} ${it.name};')
        .join('\n\n');
  }

  @override
  String toString() {
    return '''
class $classFullName {
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

class _ConstructorTemplate {
  final RecordClassTemplate _class;

  _ConstructorTemplate(this._class);

  String _parameter(TypeField field) => field.isNamed && field.isMandatory
      ? 'required this.${field.name}'
      : 'this.${field.name}';

  ParametersTemplate get _parameters => ParametersTemplate(
        unnamedMandatoryParams: _class.model.fields
            .where((it) => it.isUnnamedMandatory)
            .map(_parameter),
        enclosedParams: _class.model.fields
            .where((it) => !it.isUnnamedMandatory)
            .map(_parameter),
        enclosedParamsAreNamed:
            _class.model.fields.any((it) => it.isNamed),
      );

  @override
  String toString() {
    return '${_class.className}($_parameters);';
  }
}

class _CopyWithMethodTemplate {
  final RecordClassTemplate _class;

  _CopyWithMethodTemplate(this._class);

  String get _returnType => _class.parameterizedClassName;

  String _parameter(TypeField field) =>
      '${field.type.nullableName} ${field.name}';

  String get _parameters => [
        ..._class.model.fields.where((it) => it.isUnnamedMandatory),
        ..._class.model.fields.where((it) => !it.isUnnamedMandatory),
      ].map(_parameter).join(', ');

  String _ctorArgument(TypeField field) => field.isNamed
      ? '${field.name}: ${field.name} ?? this.${field.name}'
      : '${field.name} ?? this.${field.name}';

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
