import 'package:code_builder/code_builder.dart';
import 'package:typedefx_generator/src/model/cases.dart';
import 'package:typedefx_generator/src/template/equals_method_template.dart'
    as equalsMethod;
import 'package:typedefx_generator/src/template/hash_code_method_template.dart'
    as hashCodeMethod;
import 'package:typedefx_generator/src/template/to_string_method_template.dart'
    as toStringMethod;

Iterable<Spec> inflate(CasesType type) => [
      _class(type),
      _enum(type),
      // if (_shuoldGenerateCommonClass(type)) _commonClass(type),
    ];

Enum _enum(CasesType type) {
  final en = EnumBuilder()
    ..name = _enumName(type)
    ..values.addAll(_enumValues(type));
  return en.build();
}

Iterable<EnumValue> _enumValues(CasesType type) =>
    type.cases.map(_enumValue);

EnumValue _enumValue(Case parameter) {
  final value = EnumValueBuilder()..name = _enumValueName(parameter);
  return value.build();
}

String _enumValueName(Case parameter) => _upperCamelCase(parameter.name);

String _upperCamelCase(String name) {
  if (name.length < 2) return name.toUpperCase();
  return name[0].toUpperCase() + name.substring(1);
}

String _enumName(CasesType type) => '_\$${type.name}Case';

Class _class(CasesType type) {
  final klass = ClassBuilder()
    ..name = _casesClassName(type)
    ..types.addAll(_typeParameters(type))
    ..constructors.addAll(_constructors(type))
    ..fields.add(_caseField(type))
    ..fields.addAll(_fields(type))
    ..methods.addAll(_methods(type));
  // if (_shuoldGenerateCommonClass(type)) {
  //   klass.cases.add(_commonField(type));
  // }
  return klass.build();
}

String _casesClassName(CasesType type) => type.name;

Field _caseField(CasesType type) {
  final field = FieldBuilder()
    ..name = '_\$case'
    ..type = refer(_enumName(type))
    ..modifier = FieldModifier.final$;
  return field.build();
}

// Field _commonField(CasesType type) {
//   final field = FieldBuilder()
//     ..name = 'common'
//     ..type = refer(_commonClassName(type))
//     ..modifier = FieldModifier.final$
//     ..assignment = Code('${_commonClassName(type)}()');
//   return field.build();
// }

Iterable<Reference> _typeParameters(CasesType type) =>
    type.typeParameters.map((it) {
      final name = it.name;
      final bound = it.bound?.name;
      return bound != null ? '$name extends $bound' : name;
    }).map((it) => refer(it));

/*

  Result.data(int data)
      : _case = ResultCase.Data,
        this.data = data,
        this.error = null;
*/

Iterable<Constructor> _constructors(CasesType type) => [
      _internalConstructor(type),
      ...type.cases.map((it) => _constructor(type, it)),
    ];

Constructor _internalConstructor(CasesType type) {
  final ctor = ConstructorBuilder()
    ..name = '_'
    ..requiredParameters.addAll(
      [
        r'_$case',
        ...type.cases.map((it) => it.name),
      ].map((name) => Parameter((p) => p..name = 'this.$name')),
    );
  // if (_shuoldGenerateCommonClass(type)) {
  //   ctor.body = Code(r'common._$cases = this;');
  // }
  return ctor.build();
}

Constructor _constructor(CasesType type, Case caze) {
  final ctor = ConstructorBuilder()
    ..name = caze.name
    ..requiredParameters.add(_constructorParameter(caze))
    ..initializers.add(_constructorInitializer(type, caze));
  return ctor.build();
}

Code _constructorInitializer(CasesType type, Case field) {
  final args = [
    '${_enumName(type)}.${_enumValueName(field)}',
    ...type.cases.map((it) => it.name == field.name ? it.name : 'null'),
  ].join(', ');
  return Code('this._($args)');
}

Parameter _constructorParameter(Case field) {
  final parameter = ParameterBuilder()
    ..name = field.name
    ..type = refer(field.type.name);
  return parameter.build();
}

Field _field(Case caze) {
  final field_ = FieldBuilder()
    ..name = caze.name
    ..type = refer(_fieldType(caze))
    ..modifier = FieldModifier.final$;
  return field_.build();
}

String _fieldType(Case caze) {
  return caze.type.isNullable ? caze.type.name : '${caze.type.name}?';
}

Iterable<Field> _fields(CasesType type) => type.cases.map(_field);

Iterable<Method> _methods(CasesType type) => [
      hashCodeMethod.inflate(
        fieldNames: [
          ...type.cases.map((it) => it.name),
          '_\$case',
        ],
      ),
      equalsMethod.inflate(
        className: _parameterizedCasesClassName(type),
        fieldNames: type.cases.map((it) => it.name),
      ),
      toStringMethod.inflate(
        className: type.name,
        fieldNames: type.cases.map((it) => it.name),
      ),
      _mapMethod(type),
      _matchMethod(type),
      ...type.cases.map((field) => _hasMethod(type, field)),
    ];

/*
  $R map<$R>(
    $R Function(int value) data,
    $R Function(String value) error,
  ) {
    switch (_$case) {
      case ResultCase.Data:
        return data(this.data!);
      case ResultCase.Error:
        return error(this.error!);
    }
  }
*/

Method _mapMethod(CasesType type) {
  final method = MethodBuilder()
    ..name = 'map'
    ..types.addAll([refer(r'$R')])
    ..returns = refer(r'$R')
    ..requiredParameters.addAll(type.cases.map(
      (field) => Parameter(
        (p) => p
          ..name = field.name
          ..type = refer('\$R Function(${field.type.name} value)'),
      ),
    ))
    ..body = Code([
      'switch (_\$case) {',
      ...type.cases.map((field) => '''
      case ${_enumName(type)}.${_enumValueName(field)}:
        return ${field.name}(this.${field.name}!);
      '''),
      '}',
    ].join('\n'));
  return method.build();
}

/*

  $R? match<$R>({
    $R? Function(int value)? data,
    $R? Function(String value)? error,
    $R? Function(CResult value)? otherwise,
  }) {
    switch (_\$case) {
      case ResultCase.Data:
        if (data != null) return data(this.data!);
        break;
      case ResultCase.Error:
        if (error != null) return error(this.error!);
        break;
    }
    return otherwise?.call(this);
  }
*/

Method _matchMethod(CasesType type) {
  final method = MethodBuilder()
    ..name = 'match<\$R>'
    ..returns = refer(r'$R?')
    ..optionalParameters.addAll(type.cases.map(
      (field) => Parameter(
        (p) => p
          ..name = field.name
          ..type = refer('\$R Function(${field.type.name} value)?')
          ..named = true,
      ),
    ))
    ..optionalParameters.add(
      Parameter(
        (p) => p
          ..name = 'otherwise'
          ..type = refer(
              '\$R Function(${_parameterizedCasesClassName(type)} value)?')
          ..named = true,
      ),
    )
    ..body = Code([
      'switch (_\$case) {',
      ...type.cases.map((field) => '''
      case ${_enumName(type)}.${_enumValueName(field)}:
        if (${field.name} != null) return ${field.name}(this.${field.name}!);
        break;
      '''),
      '}',
      'return otherwise?.call(this);',
    ].join('\n'));
  return method.build();
}

/*
  bool get hasError => _case == ResultCase.Error;
*/

Method _hasMethod(CasesType type, Case field) {
  final method = MethodBuilder();
  method
    ..name = 'has${_upperCamelCase(field.name)}'
    ..returns = refer('bool')
    ..type = MethodType.getter
    ..lambda = true
    ..body =
        Code('_\$case == ${_enumName(type)}.${_enumValueName(field)}');
  return method.build();
}

String _parameterizedCasesClassName(CasesType type) {
  final params = type.typeParameters.map((it) => it.name);
  return params.isEmpty
      ? '${type.name}'
      : '${type.name}<${params.join(', ')}>';
}

/*
String _commonClassName(CasesType type) => '_\$${type.name}Common';

Class _commonClass(CasesType type) {
  final klass = ClassBuilder()
    ..name = _commonClassName(type)
    ..types.addAll(_typeParameters(type))
    ..cases.add(_casesField(type))
    ..methods.addAll(_commonGetters(type));
  if (_shouldGenerateCopyWithMethod(type)) {
    klass.methods.add(_copyWithMethod(type));
  }
  return klass.build();
}

Field _casesField(CasesType type) {
  final param = FieldBuilder()
    ..name = r'_$cases'
    ..type = refer('late final ${_parameterizedCasesClassName(type)}');
  return param.build();
}

Iterable<Method> _commonGetters(CasesType type) =>
    _commonFields(type).map((field) => _commonGetter(type, field));

Iterable<Case> _commonFields(CasesType type) {
  return _intersection(type.cases.map(_apparentFieldsOfFieldType));
}

Iterable<Case> _apparentFieldsOfFieldType(Case field) {
  final typeMeta = field.typeMeta;
  if (typeMeta == null) return <Case>[];
  return _apparentFieldsOfType(typeMeta);
}

Iterable<Case> _apparentFieldsOfType(TType type) {
  if (type is RecordType || type is StructType) return type.cases;
  if (type is CompositeType) return type.cases;
  if (type is CasesType) return _commonFields(type);
  throw Exception('should not be reached');
}

Iterable<Case> _intersection(Iterable<Iterable<Case>> groups) {
  if (groups.isEmpty) return [];
  if (groups.length == 1) return groups.first;
  return groups.skip(1).fold<Iterable<Case>>(
        groups.first,
        (prev, cur) => _intersectionOf(prev, cur),
      );
}

Iterable<Case> _intersectionOf(
        Iterable<Case> left, Iterable<Case> right) =>
    left.toList()
      ..removeWhere(
        (field) => !right.any(
          (it) => _areFieldsSame(field, it),
        ),
      );

bool _areFieldsSame(Case left, Case right) =>
    left.name == right.name && left.type.name == right.type.name;

Method _commonGetter(CasesType type, Case field) {
  final method = MethodBuilder()
    ..name = field.name
    ..returns = refer(field.type.name)
    ..type = MethodType.getter
    ..body = Code([
      r'switch (_$cases._$case) {',
      ...type.cases.map((case_) => '''
      case ${_enumName(type)}.${_enumValueName(case_)}:
        return _\$cases.${case_.name}!.${field.name};
      '''),
      '}',
    ].join('\n'));
  return method.build();
}

bool _shuoldGenerateCommonClass(CasesType type) =>
    _commonFields(type).isNotEmpty;

/*
  Result<T> copyWith({int? id}) {
    switch (_$result._$case) {
      case _$ResultCase.Data:
        return Result.data(_$result.data!.copyWith(id: id));
      case _$ResultCase.Error:
        return Result.error(_$result.error!.copyWith(id: id));
    }
  }
*/

Method _copyWithMethod(CasesType type) {
  final fields = _commonFields(type);
  final method = MethodBuilder()
    ..name = 'copyWith'
    ..returns = refer(_parameterizedCasesClassName(type))
    ..optionalParameters.addAll(
      fields.map(
        (field) => Parameter(
          (param) => param
            ..name = field.name
            ..type = refer(_nullableType(field))
            ..named = true,
        ),
      ),
    )
    ..body = () {
      final copyWithArgs =
          fields.map((it) => '${it.name}: ${it.name}').join(', ');
      return Code([
        r'switch (_$cases._$case) {',
        ...type.cases.map((case_) => '''
        case ${_enumName(type)}.${_enumValueName(case_)}:
          return ${_casesClassName(type)}.${case_.name}(_\$cases.${case_.name}!.copyWith($copyWithArgs));
          '''),
        '}',
      ].join('\n'));
    }();
  return method.build();
}

String _nullableType(Case caze) =>
    caze.type ? caze.type.name : '${caze.type.name}?';

bool _shouldGenerateCopyWithMethod(CasesType type) =>
    type.commonFields.isNotEmpty &&
    type.cases.every((caze) => caze.type.source is RecordType);
*/
