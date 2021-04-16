import 'package:typedefx_generator/src/element/common.dart';

class TargetLibraryElement {
  final Iterable<String> imports;
  final Uri uri;
  final Iterable<TypedefxElement> elements;

  TargetLibraryElement({
    required this.imports,
    required this.uri,
    required this.elements,
  });
}
