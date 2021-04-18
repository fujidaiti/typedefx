import 'package:typedefx_generator/src/model/common.dart';
import 'package:typedefx_generator/src/utils.dart';

abstract class ClassTemplate {
  abstract final TypedefxType model;

  String get className => model.name;

  String get parameterizedClassName {
    final params = model.typeParameters.map((it) => it.name);
    return params.isEmpty
        ? '$className'
        : '$className<${params.join(', ')}>';
  }

  String get classFullName => '$className$typeParameters';

  String get typeParameters => model.typeParameters
      .map(
        (type) =>
            type.bound?.let((it) => '${type.name} extends ${it.name}') ??
            type.name,
      )
      .let((it) => it.isNotEmpty ? '<${it.join(', ')}>' : '');
}
