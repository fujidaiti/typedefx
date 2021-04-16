import 'dart:async';

import 'package:build/build.dart';
import 'package:typedefx_generator/src/parser/target_library.dart';
import 'package:typedefx_generator/src/template/library_template.dart';
import 'package:typedefx_generator/src/transformer.dart';
import 'package:source_gen/source_gen.dart';

class RecordGenerator extends Generator {
  FutureOr<String> generate(
    LibraryReader library,
    BuildStep buildStep,
  ) {
    // return write(inflate(transform(parse(library))));
    return LibraryTemplate(transform(parse(library))).toString();
  }
}
