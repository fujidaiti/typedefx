import 'package:typedefx_generator/src/element/cases.dart';
import 'package:typedefx_generator/src/model/cases.dart';
import 'package:typedefx_generator/src/model/common.dart';
import 'package:typedefx_generator/src/transform/common.dart';
import 'package:typedefx_generator/src/transform/record.dart' as Rec;

CasesType transform(CasesElement element) => CasesType(
      name: element.name,
      typeParameters: transformTypeParameters(element.typeParameters),
      cases: element.parameters.map(_case),
    );

Case _case(CaseElement element) {
  final name = element.name;
  final type = ConcreteType(
    name: element.type.source,
    uri: dependencyUri(element.type),
    isNullable: element.type.isNullable,
  );
  final elementType = element.type;
  if (elementType is RecordCaseTypeElement)
    return RecordCase(
      name: name,
      type: type,
      typeSpec: Rec.transform(elementType.element),
    );
  if (elementType is CasesCaseTypeElement)
    return CasesCase(
      name: name,
      type: type,
      typeSpec: transform(elementType.element),
    );
  return AnyCase(name: name, type: type, typeSpec: null);
}
