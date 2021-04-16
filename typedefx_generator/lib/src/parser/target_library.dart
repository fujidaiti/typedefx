import 'package:analyzer/dart/element/element.dart' as E;
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:typedefx_generator/src/parser/record.dart' as Rec;
import 'package:typedefx_generator/src/parser/cases.dart' as Cas;
import 'package:typedefx_generator/src/parser/common.dart';
import 'package:typedefx_generator/src/utils.dart';
import 'package:typedefx_generator/src/element/common.dart';
import 'package:typedefx_generator/src/element/target_library.dart';

TargetLibraryElement parse(
  LibraryReader library,
) =>
    TargetLibraryElement(
      imports:
          library.element.imports.map((it) => it.uri).whereType<String>(),
      uri: library.element.source.uri,
      elements: library.allElements
          .whereType<E.TypeAliasElement>()
          .map(_tryParseTypeAlias)
          .whereType<TypedefxElement>(),
    );

TypedefxElement? _tryParseTypeAlias(E.TypeAliasElement element) {
  if (TypedefxChecker.hasAnnotationOf(element))
    return _parseTypeAlias(element);
  return null;
}

TypedefxElement _parseTypeAlias(E.TypeAliasElement element) {
  final bool isRecord = RecordChecker.hasAnnotationOf(element);
  final bool isCases = CasesChecker.hasAnnotationOf(element);
  if (isRecord && isCases) {
    throw InvalidGenerationSourceError(
      "Can't use @record and @cases, @composite at the same time",
      element: element,
    );
  }
  if (isRecord) return Rec.parse(element);
  if (isCases) return Cas.parse(element);
  throw Exception("Shuold not be reached");
}

TypedefxElement? tryParseDependentType(DartType type) =>
    type.toAliasOrNull()?.let(_tryParseTypeAlias);
