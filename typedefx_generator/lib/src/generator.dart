import 'dart:async';

import 'package:build/build.dart';
import 'package:typedefx_generator/src/parser/target_library.dart';
import 'package:typedefx_generator/src/template/library_template.dart';
import 'package:typedefx_generator/src/transform/library.dart';
import 'package:source_gen/source_gen.dart';

class RecordGenerator extends Generator {
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    final generatedLibrary = transform(parse(library));
    if (generatedLibrary.isEmpty) return '';
    return LibraryTemplate(generatedLibrary).toString();
  }
}
