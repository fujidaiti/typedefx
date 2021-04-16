import 'package:typedefx_generator/src/config.dart';
import 'package:typedefx_generator/src/utils.dart';
import 'package:typedefx_generator/src/element/common.dart';
import 'package:typedefx_generator/src/model/common.dart';

Iterable<TypeParameter> transformTypeParameters(
        Iterable<TypeParameterElement> elements) =>
    elements.map(
      (it) => TypeParameter(
        name: it.name,
        bound: it.bound?.let(
          (bound) => ConcreteType(
            name: bound.source,
            uri: dependencyUri(bound),
            isNullable: bound.isNullable,
          ),
        ),
      ),
    );

String? dependencyUri(DependentElement dependency) {
  final uri = dependency.uri;
  if (uri == null) return null;
  if (_isCoreLibrary(uri)) return null;
  if (dependency.doesRepresentTypedefxElement)
    return generatedFileUri(uri);
  return uri.toString();
}

bool _isCoreLibrary(Uri uri) => uri.toString().startsWith('dart:core');

String generatedFileUri(Uri uri) =>
    uri.toString().replaceFirst('.dart', generated_file_extension);
