import 'package:typedefx_generator/src/transform/common.dart';
import 'package:typedefx_generator/src/element/record.dart';
import 'package:typedefx_generator/src/model/common.dart';
import 'package:typedefx_generator/src/model/record.dart';

RecordType transform(RecordElement element) => RecordType(
      name: element.name,
      typeParameters: transformTypeParameters(element.typeParameters),
      fields: _fields(element.parameters),
    );

Iterable<TypeField> _fields(Iterable<RecordFieldElement> elements) {
  final fields = <String, TypeField>{};
  final omittedFields = <String>[];
  elements.forEach((element) {
    if (element is RecordSpreadFieldElement) {
      _spreadRrecord(
        record: transform(element.type.element),
        asNamed: element.isNamed,
        asMandatory: element.isMandatory,
        forceAsNullable: element.type.isNullable,
      ).forEach((field) => fields[field.name] = field);
    } else if (element is RecordOmitFieldElement) {
      omittedFields.add(element.name);
    } else {
      final field = _field(element);
      fields[field.name] = field;
    }
  });
  omittedFields.forEach((field) => fields.remove(field));
  return fields.values;
}

TypeField _field(
  RecordFieldElement element,
) =>
    TypeField(
      name: element.name,
      type: ConcreteType(
        name: element.type.source,
        uri: dependencyUri(element.type),
        isNullable: element.type.isNullable,
      ),
      isMandatory: element.isMandatory,
      isNamed: element.isNamed,
    );

Iterable<TypeField> _spreadRrecord({
  required RecordType record,
  required bool asNamed,
  required bool asMandatory,
  required bool forceAsNullable,
}) =>
    record.fields.map(
      (field) => TypeField(
        name: field.name,
        type: ConcreteType(
          name: field.type.name,
          isNullable: forceAsNullable || field.type.isNullable,
          uri: field.type.uri,
        ),
        isMandatory: asMandatory,
        isNamed: asNamed,
      ),
    );
