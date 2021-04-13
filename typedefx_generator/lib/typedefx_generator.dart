library typedefx_generator;

import 'package:build/build.dart';
import 'package:typedefx_generator/src/config.dart';
import 'package:typedefx_generator/src/generator.dart';
import 'package:source_gen/source_gen.dart';

Builder typedefx_generator(BuilderOptions options) => LibraryBuilder(
      RecordGenerator(),
      generatedExtension: generated_file_extension,
    );
