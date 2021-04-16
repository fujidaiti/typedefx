import 'package:analyzer/dart/element/element.dart' as E;
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:typedefx/typedefx.dart';
import 'package:typedefx_generator/src/utils.dart';

const TypedefxChecker = const TypeChecker.fromRuntime(Typedefx);
const RecordChecker = const TypeChecker.fromRuntime(Record);
const CasesChecker = const TypeChecker.fromRuntime(Cases);
const SpreadChecker = const TypeChecker.fromRuntime(Spread);
const OmitChecker = const TypeChecker.fromRuntime(Omit);

extension TypeAliasElementUtils on E.TypeAliasElement {
  Iterable<E.ParameterElement> parameters() =>
      (this.aliasedElement as E.GenericFunctionTypeElement).parameters;
}

extension DartTypeUtils on DartType {
  Uri? uri() => this.element?.source?.uri;

  bool doesRepresentTypedefxElement() => toAliasOrNull() != null;

  E.TypeAliasElement? toAliasOrNull() {
    final element = this.element;
    if (element == null) return null;
    if (element is E.TypeAliasElement) return element;
    final enclosed = element.enclosingElement;
    if (enclosed is E.TypeAliasElement) return enclosed;
    return null;
  }

  bool isNullable() =>
      this.nullabilitySuffix == NullabilitySuffix.question;
}

extension ParameterElementUtils on E.ParameterElement {
  String typeSource() {
    final source = this.type.toAliasOrNull()?.let(
      (alias) {
        final src = this.source!.contents.data;
        final pattern = alias.name + r'\s*(<.+>)?\s*\??\s*$';
        return RegExp(pattern)
            .firstMatch(src.substring(0, this.nameOffset))
            ?.group(0)
            ?.trim();
      },
    );
    return source ?? this.type.toString();
  }
}
