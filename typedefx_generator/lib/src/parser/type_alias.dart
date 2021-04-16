import 'package:analyzer/dart/element/element.dart' as E;
import 'package:typedefx_generator/src/element/common.dart';
import 'package:typedefx_generator/src/utils.dart';
import 'package:typedefx_generator/src/parser/common.dart';

Iterable<TypeParameterElement> typeParameters(
  E.TypeAliasElement element,
) =>
    element.typeParameters.map(
      (param) => TypeParameterElement(
        name: param.name,
        bound: param.bound?.let(
          (bound) => DependentElement(
            source: bound.toString(),
            isTypedefxElement: bound.doesRepresentTypedefxElement(),
            uri: bound.uri(),
            isNullable: bound.isNullable(),
          ),
        ),
      ),
    );
