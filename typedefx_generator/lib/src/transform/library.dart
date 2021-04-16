import 'package:typedefx_generator/src/element/target_library.dart';
import 'package:typedefx_generator/src/element/record.dart';
import 'package:typedefx_generator/src/element/cases.dart';
import 'package:typedefx_generator/src/model/generated_library.dart';
import 'package:typedefx_generator/src/transform/common.dart';
import 'package:typedefx_generator/src/transform/record.dart' as Rec;
import 'package:typedefx_generator/src/transform/cases.dart' as Cas;

GeneratedLibrary transform(TargetLibraryElement library) =>
    GeneratedLibrary(
      records:
          library.elements.whereType<RecordElement>().map(Rec.transform),
      cases: library.elements.whereType<CasesElement>().map(Cas.transform),
      composites: [],
      uri: generatedFileUri(library.uri),
      originalUri: library.uri.toString(),
      exportOriginalUri:
          _shouldExportOriginalUriFromGeneratedFile(library),
    );

bool _shouldExportOriginalUriFromGeneratedFile(
        TargetLibraryElement library) =>
    library.imports
        .any((it) => it == 'package:typedefx/typedefx_export.dart');
