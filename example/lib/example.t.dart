// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RecordGenerator
// **************************************************************************

import 'package:typedefx/typedefx.dart';

export 'package:example/example.dart'
    hide Data, Error, Task, TaskSummary, Result, Either;

class Data<T extends num> {
  final int id;

  final String datetime;

  final T value;

  Data({required this.id, required this.datetime, required this.value});

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Data<T> &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.datetime, datetime) ||
                const DeepCollectionEquality()
                    .equals(other.datetime, datetime)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(datetime) ^
      const DeepCollectionEquality().hash(value);

  @override
  String toString() => 'Data(id: $id, datetime: $datetime, value: $value)';

  Data<T> copyWith({int? id, String? datetime, T? value}) => Data(
      id: id ?? this.id,
      datetime: datetime ?? this.datetime,
      value: value ?? this.value);
}

class Error {
  final int id;

  final String datetime;

  final String? message;

  final int? code;

  Error(this.id, {required this.datetime, this.message, required this.code});

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Error &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.datetime, datetime) ||
                const DeepCollectionEquality()
                    .equals(other.datetime, datetime)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(datetime) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(code);

  @override
  String toString() =>
      'Error(id: $id, datetime: $datetime, message: $message, code: $code)';

  Error copyWith({int? id, String? datetime, String? message, int? code}) =>
      Error(id ?? this.id,
          datetime: datetime ?? this.datetime,
          message: message ?? this.message,
          code: code ?? this.code);
}

class Task {
  final String id;

  final String datetime;

  final String owner;

  Task(this.id, this.datetime, this.owner);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Task &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.datetime, datetime) ||
                const DeepCollectionEquality()
                    .equals(other.datetime, datetime)) &&
            (identical(other.owner, owner) ||
                const DeepCollectionEquality().equals(other.owner, owner)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(datetime) ^
      const DeepCollectionEquality().hash(owner);

  @override
  String toString() => 'Task(id: $id, datetime: $datetime, owner: $owner)';

  Task copyWith({String? id, String? datetime, String? owner}) =>
      Task(id ?? this.id, datetime ?? this.datetime, owner ?? this.owner);
}

class TaskSummary {
  final String? id;

  final String? datetime;

  TaskSummary([this.id, this.datetime]);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is TaskSummary &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.datetime, datetime) ||
                const DeepCollectionEquality()
                    .equals(other.datetime, datetime)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(datetime);

  @override
  String toString() => 'TaskSummary(id: $id, datetime: $datetime)';

  TaskSummary copyWith({String? id, String? datetime}) =>
      TaskSummary(id ?? this.id, datetime ?? this.datetime);
}

enum _$ResultCase { data, error }

class _$ResultFactory {
  const _$ResultFactory();

  Result<T> data<T extends num>(
          {required int id, required String datetime, required T value}) =>
      Result.data(Data(id: id, datetime: datetime, value: value));

  Result<T> error<T extends num>(int id,
          {required String datetime, String? message, required int? code}) =>
      Result.error(Error(id, datetime: datetime, message: message, code: code));
}

class Result<T extends num> {
  static final of = _$ResultFactory();

  Result._(this._$case, this.data, this.error);

  Result.data(Data<T> data) : this._(_$ResultCase.data, data, null);

  Result.error(Error error) : this._(_$ResultCase.error, null, error);

  final _$ResultCase _$case;

  final Data<T>? data;

  final Error? error;

  bool get hasData => _$case == _$ResultCase.data;

  bool get hasError => _$case == _$ResultCase.error;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Result<T> &&
            (identical(other._$case, _$case) ||
                const DeepCollectionEquality().equals(other._$case, _$case)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(_$case) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(error);

  @override
  String toString() => 'Result(data: $data, error: $error)';

  $R map<$R>($R Function(Data<T>? value) data, $R Function(Error value) error) {
    switch (_$case) {
      case _$ResultCase.data:
        return data(this.data);

      case _$ResultCase.error:
        return error(this.error!);
    }
  }

  $R? match<$R>(
      {$R Function(Result<T> value)? otherwise,
      $R Function(Data<T>? value)? data,
      $R Function(Error value)? error}) {
    switch (_$case) {
      case _$ResultCase.data:
        if (data != null) return data(this.data);
        break;

      case _$ResultCase.error:
        if (error != null) return error(this.error!);
        break;
    }
    return otherwise?.call(this);
  }
}

enum _$EitherCase { result, none }

class Either<T extends num> {
  Either._(this._$case, this.result, this.none);

  Either.result(Result<T> result) : this._(_$EitherCase.result, result, null);

  Either.none(int none) : this._(_$EitherCase.none, null, none);

  final _$EitherCase _$case;

  final Result<T>? result;

  final int? none;

  bool get hasResult => _$case == _$EitherCase.result;

  bool get hasNone => _$case == _$EitherCase.none;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Either<T> &&
            (identical(other._$case, _$case) ||
                const DeepCollectionEquality().equals(other._$case, _$case)) &&
            (identical(other.result, result) ||
                const DeepCollectionEquality().equals(other.result, result)) &&
            (identical(other.none, none) ||
                const DeepCollectionEquality().equals(other.none, none)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(_$case) ^
      const DeepCollectionEquality().hash(result) ^
      const DeepCollectionEquality().hash(none);

  @override
  String toString() => 'Either(result: $result, none: $none)';

  $R map<$R>($R Function(Result<T> value) result, $R Function(int value) none) {
    switch (_$case) {
      case _$EitherCase.result:
        return result(this.result!);

      case _$EitherCase.none:
        return none(this.none!);
    }
  }

  $R? match<$R>(
      {$R Function(Either<T> value)? otherwise,
      $R Function(Result<T> value)? result,
      $R Function(int value)? none}) {
    switch (_$case) {
      case _$EitherCase.result:
        if (result != null) return result(this.result!);
        break;

      case _$EitherCase.none:
        if (none != null) return none(this.none!);
        break;
    }
    return otherwise?.call(this);
  }
}
