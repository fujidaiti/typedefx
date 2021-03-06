import 'package:typedefx_generator/src/model/cases.dart';
import 'package:typedefx_generator/src/model/common.dart';
import 'package:typedefx_generator/src/template/parameters_template.dart';
import 'package:typedefx_generator/src/utils.dart';
import 'package:typedefx_generator/src/template/class_template.dart';
import 'package:typedefx_generator/src/template/equals_method_template.dart';
import 'package:typedefx_generator/src/template/hash_code_method_template.dart';
import 'package:typedefx_generator/src/template/to_string_method_template.dart';

class CasesClassTemplate extends ClassTemplate {
  @override
  final CasesType model;

  CasesClassTemplate(this.model);

  _CaseEnumTemplate get caseEnum => _CaseEnumTemplate(model);

  String get _privateCtor {
    final args = [
      r'this._$case',
      ...model.cases.map((it) => 'this.${it.name}'),
    ].join(', ');
    return '$className._($args);';
  }

  String _namedCtor(Case caze) {
    final redirectionArgs = [
      '${caseEnum.name}.${caseEnum.value(caze)}',
      ...model.cases.map((it) => it.name == caze.name ? it.name : 'null'),
    ].join(', ');
    final redirection = 'this._($redirectionArgs)';
    final params = '${caze.type.name} ${caze.name}';
    return '$className.${caze.name}($params) : $redirection;';
  }

  String get _namedCtors => model.cases.map(_namedCtor).join('\n\n');

  String _caseField(Case caze) =>
      'final ${caze.type.nullableName} ${caze.name};';

  String get _caseFields => model.cases.map(_caseField).join('\n\n');

  String _hasMethod(Case caze) => '''
    bool get has${caze.name.capitalizeFirstLetter()} => 
      _\$case == ${caseEnum.name}.${caseEnum.value(caze)};
  ''';

  String get _hasMethods => model.cases.map(_hasMethod).join('\n\n');

  EqualsMethodTemplate get _equalsMethod => EqualsMethodTemplate(
        className: parameterizedClassName,
        fields: [
          r'_$case',
          ...model.cases.map((it) => it.name),
        ],
      );

  HashCodeMethodTemplate get _hashCodeMethod => HashCodeMethodTemplate(
        fields: [
          r'_$case',
          ...model.cases.map((it) => it.name),
        ],
      );

  ToStringMethodTemplate get _toStringMethod => ToStringMethodTemplate(
        label: className,
        fields: model.cases.map((it) => it.name),
      );

  _MapMethodTemplate get _mapMethod => _MapMethodTemplate(this);

  _MatchMethodTemplate get _matchMethod => _MatchMethodTemplate(this);

  _FactoryClassTemplate get _factoryClass => _FactoryClassTemplate(this);

  String get _staticFactory =>
      'static final of = ${_factoryClass.name}();';

  bool _shouldGenerateFactoryClass() =>
      model.cases.any((it) => it is RecordCase);

  @override
  String toString() {
    return '''
    $caseEnum

    ${_shouldGenerateFactoryClass() ? _factoryClass : ''}

    class $classFullName {
      ${_shouldGenerateFactoryClass() ? _staticFactory : ''}
      
      $_privateCtor
      
      $_namedCtors
      
      final ${caseEnum.name} _\$case;

      $_caseFields

      $_hasMethods

      $_equalsMethod

      $_hashCodeMethod

      $_toStringMethod

      $_mapMethod

      $_matchMethod
    }
    ''';
  }
}

class _CaseEnumTemplate {
  final CasesType model;

  _CaseEnumTemplate(this.model);

  String get name => '_\$${model.name}Case';

  String value(Case caze) => caze.name;

  String get values => model.cases.map(value).join(', ');

  @override
  String toString() {
    return 'enum $name { $values }';
  }
}

class _MapMethodTemplate {
  final CasesClassTemplate _class;

  _MapMethodTemplate(this._class);

  String _parameter(Case caze) =>
      '\$R Function(${caze.type.nameWithNullabilitySuffix} value) ${caze.name}';

  String get _parameters => _class.model.cases.map(_parameter).join(', ');

  String _caseStatement(Case caze) {
    final exclamationMark = caze.type.isNullable ? '' : '!';
    return '''
    case ${_class.caseEnum.name}.${_class.caseEnum.value(caze)}:
      return ${caze.name}(this.${caze.name}$exclamationMark);
  ''';
  }

  String get _caseStatements =>
      _class.model.cases.map(_caseStatement).join('\n');

  @override
  String toString() {
    return '''
    \$R map<\$R>($_parameters) {
      switch (_\$case) {
        $_caseStatements
      }
    }
    ''';
  }
}

class _MatchMethodTemplate {
  final CasesClassTemplate _class;

  _MatchMethodTemplate(this._class);

  String _parameter(Case caze) =>
      '\$R Function(${caze.type.nameWithNullabilitySuffix} value)? ${caze.name}';

  String get _parameters => [
        '\$R Function(${_class.parameterizedClassName} value)? otherwise',
        ..._class.model.cases.map(_parameter),
      ].join(', ');

  String _caseStatement(Case caze) {
    final exclamationMark = caze.type.isNullable ? '' : '!';
    return '''
    case ${_class.caseEnum.name}.${_class.caseEnum.value(caze)}:
      if (${caze.name} != null) return ${caze.name}(this.${caze.name}$exclamationMark);
      break;
    ''';
  }

  String get _caseStatements =>
      _class.model.cases.map(_caseStatement).join('\n');

  @override
  String toString() {
    return '''
    \$R? match<\$R>({$_parameters}) {
      switch (_\$case) {
        $_caseStatements
      }
      return otherwise?.call(this);
    }
    ''';
  }
}

/*

class _$ResultFactory {
  const _$ResultFactory();

  Result<T> data<T extends num>(
    int id,
    String datetime,
    T value,
  ) =>
      Result.data(
        Data(
          id: id,
          datetime: datetime,
          value: value,
        ),
      );
}

*/

class _FactoryClassTemplate {
  final CasesClassTemplate klass;

  _FactoryClassTemplate(this.klass);

  String get name => '_\$${klass.model.name}Factory';

  String _methodParameter(TypeField field) {
    if (field.isNamed && field.isMandatory)
      return 'required ${field.type.nameWithNullabilitySuffix} ${field.name}';
    return '${field.type.nameWithNullabilitySuffix} ${field.name}';
  }

  String get factoryMethods => [
        ...klass.model.cases.whereType<RecordCase>().map(
              (it) => _FactoryMethodTemplate(
                klass: klass,
                methodName: it.name,
                ctorName: it.typeSpec.name,
                parameters: ParametersTemplate(
                  unnamedMandatoryParams: it.typeSpec.fields
                      .where((field) => field.isUnnamedMandatory)
                      .map(_methodParameter),
                  enclosedParams: it.typeSpec.fields
                      .where((field) => field.isNamed)
                      .map(_methodParameter),
                  enclosedParamsAreNamed:
                      it.typeSpec.fields.any((field) => field.isNamed),
                ),
                arguments: [
                  ...it.typeSpec.fields
                      .where((field) => !field.isNamed)
                      .map((it) => it.name),
                  ...it.typeSpec.fields
                      .where((field) => field.isNamed)
                      .map((it) => '${it.name}: ${it.name}'),
                ].join(', '),
              ),
            ),
      ].join('\n\n');

  @override
  String toString() {
    return '''
    class $name {
      const $name();

      $factoryMethods
    }
    ''';
  }
}

class _FactoryMethodTemplate {
  final CasesClassTemplate klass;
  final ParametersTemplate parameters;
  final String arguments;
  final String methodName;
  final String ctorName;

  _FactoryMethodTemplate({
    required this.klass,
    required this.parameters,
    required this.arguments,
    required this.methodName,
    required this.ctorName,
  });

  @override
  String toString() {
    String returns = klass.parameterizedClassName;
    final name = '$methodName${klass.typeParameters}';
    final ctorCall = '$ctorName($arguments)';
    return '''
    $returns $name($parameters) => 
      ${klass.className}.$methodName($ctorCall);
    ''';
  }
}
