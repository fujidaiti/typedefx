library example;

import 'package:typedefx/typedefx_export.dart';

@record
typedef Data<T extends num>({int id, String datetime, T value});

@record
typedef Error(
  int id, {
  String datetime,
  String? message,
  required int? code,
});

@cases
typedef Result<T extends num>(Data<T>? data, Error error);

@cases
typedef Either<T extends num>(Result<T> result, int none);

@record
typedef Task(
  String id,
  // the field type will be automatically detected (e.g. String)
  // @TaskTitle() title,
  String datetime,
  String owner,
);

// Equivalent to:
// @record
// typedef TaskSummary([
//   String? id,
//   String? datetime,
// ]);
@record
typedef TaskSummary([@spread Task? task, @omit owner]);

// class TaskTitle extends RichField<String> {
//   const TaskTitle();

//   @override
//   String? validate(String s) {
//     if (s.length <= 20) return null;
//     return 'max length of a task title is 20';
//   }

//   @override
//   String defaultValue() => '*no title*';

//   @override
//   String proxy(String value) => value.isEmpty ? defaultValue() : value;

//   @override
//   String display(String value) => 'title:$value';
// }
