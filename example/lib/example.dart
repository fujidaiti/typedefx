library example;

import 'package:typedefx/typedefx_export.dart';

@record
typedef Data<T>(int id, String datetime, T value);

@record
typedef Error(int id, String datetime, String message);

@cases
typedef Result<T>(Data<T>? data, Error error);

@cases
typedef Either<T>(Result<T> result, int none);
