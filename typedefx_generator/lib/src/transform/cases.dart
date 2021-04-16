import 'package:typedefx_generator/src/element/cases.dart';
import 'package:typedefx_generator/src/model/cases.dart';
import 'package:typedefx_generator/src/transform/common.dart';
import 'package:typedefx_generator/src/transform/record.dart' as Rec;

CasesType transform(CasesElement element) => CasesType(
      name: element.name,
      typeParameters: transformTypeParameters(element.typeParameters),
      cases: element.parameters.map(_case),
      commonFields: [],
    );

Case _case(CaseElement element) => Case(
      name: element.name,
      type: CaseType(
        name: element.type.source,
        uri: dependencyUri(element.type),
        isNullable: element.type.isNullable,
        source: () {
          final type = element.type;
          if (type is RecordCaseTypeElement)
            return Rec.transform(type.element);
          if (type is CasesCaseTypeElement) return transform(type.element);
          return null;
        }(),
      ),
    );
