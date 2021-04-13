import 'package:code_builder/code_builder.dart';
import 'package:typedefx_generator/src/models.dart';
import 'package:typedefx_generator/src/template/equals_method_template.dart'
    as equalsMethod;
import 'package:typedefx_generator/src/template/hash_code_method_template.dart'
    as hashCodeMethod;
import 'package:typedefx_generator/src/template/to_string_method_template.dart'
    as toStringMethod;
import 'package:typedefx_generator/src/template/copy_with_method_template.dart'
    as copyWithMethod;

Class inflate(RecordType type) {
  final klass = ClassBuilder()
    ..name = type.name
    ..types.addAll(_typeParameters(type))
    ..constructors.add(_constructor(type))
    ..fields.addAll(_fields(type))
    ..methods.addAll(_methods(type));
  return klass.build();
}

Iterable<Reference> _typeParameters(TType type) =>
    type.typeParameters.map((it) {
      final name = it.name;
      final bound = it.bound?.name;
      return bound != null ? '$name extends $bound' : name;
    }).map((it) => refer(it));

Constructor _constructor(TType type) {
  final ctor = ConstructorBuilder()
    ..requiredParameters.addAll(
      type.fields
          .where((it) => it.isPositional)
          .map(_constructorParameter),
    )
    ..optionalParameters.addAll(
      type.fields
          .where((it) => !it.isPositional)
          .map(_constructorParameter),
    );
  return ctor.build();
}

Parameter _constructorParameter(TTypeField field) {
  final parameter = ParameterBuilder()
    ..name = field.name
    ..toThis = true
    ..named = _shouldBeNamedParameter(field)
    ..required = _shouldBeMarkedAsRequired(field);
  return parameter.build();
}

bool _shouldBeNamedParameter(TTypeField field) => !field.isPositional;

bool _shouldBeMarkedAsRequired(TTypeField field) =>
    _shouldBeNamedParameter(field) && field.isMandatory;

Field _field(TTypeField field) {
  final field_ = FieldBuilder()
    ..name = field.name
    ..type = refer(field.type.name)
    ..modifier = FieldModifier.final$;
  return field_.build();
}

Iterable<Field> _fields(TType type) => type.fields.map(_field);

Iterable<Method> _methods(TType type) => [
      hashCodeMethod.inflate(
        fieldNames: type.fields.map((it) => it.name),
      ),
      equalsMethod.inflate(
        className: _parameterizedSelfType(type),
        fieldNames: type.fields.map((it) => it.name),
      ),
      toStringMethod.inflate(
        className: type.name,
        fieldNames: type.fields.map((it) => it.name),
      ),
      copyWithMethod.inflate(type),
    ];

String _parameterizedSelfType(TType type) {
  final params = type.typeParameters.map((it) => it.name);
  return params.isEmpty
      ? '${type.name}'
      : '${type.name}<${params.join(', ')}>';
}