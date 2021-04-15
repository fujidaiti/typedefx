// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RecordGenerator
// **************************************************************************

import 'package:typedefx/typedefx.dart';
export 'package:example/example.dart'
    hide Data, Error, Task, TaskSummary, Result, Either;

class Data<T> {
  Data(this.id, this.datetime, this.value);

  final int id;

  final String datetime;

  final T value;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(datetime) ^
      const DeepCollectionEquality().hash(value) ^
      super.hashCode;
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
  String toString() => 'Data(id: $id, datetime: $datetime, value: $value)';
  Data<T> copyWith({int? id, String? datetime, T? value}) =>
      Data(id ?? this.id, datetime ?? this.datetime, value ?? this.value);
}

class Error {
  Error(this.id, this.datetime, this.message);

  final int id;

  final String datetime;

  final String message;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(datetime) ^
      const DeepCollectionEquality().hash(message) ^
      super.hashCode;
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
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => 'Error(id: $id, datetime: $datetime, message: $message)';
  Error copyWith({int? id, String? datetime, String? message}) =>
      Error(id ?? this.id, datetime ?? this.datetime, message ?? this.message);
}

class Task {
  Task(this.id, this.datetime, this.owner);

  final String id;

  final String datetime;

  final String owner;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(datetime) ^
      const DeepCollectionEquality().hash(owner) ^
      super.hashCode;
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
  String toString() => 'Task(id: $id, datetime: $datetime, owner: $owner)';
  Task copyWith({String? id, String? datetime, String? owner}) =>
      Task(id ?? this.id, datetime ?? this.datetime, owner ?? this.owner);
}

class TaskSummary {
  TaskSummary(this.id, this.datetime);

  final String id;

  final String datetime;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(datetime) ^
      super.hashCode;
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
  String toString() => 'TaskSummary(id: $id, datetime: $datetime)';
  TaskSummary copyWith({String? id, String? datetime}) =>
      TaskSummary(id ?? this.id, datetime ?? this.datetime);
}

class Result<T> {
  Result._(this._$case, this.data, this.error);

  Result.data(Data<T>? data) : this._(_$ResultCase.Data, data, null);

  Result.error(Error error) : this._(_$ResultCase.Error, null, error);

  final _$ResultCase _$case;

  final Data<T>? data;

  final Error? error;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(_$case) ^
      super.hashCode;
  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Result<T> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  String toString() => 'Result(data: $data, error: $error)';
  $R map<$R>($R Function(Data<T>? value) data, $R Function(Error value) error) {
    switch (_$case) {
      case _$ResultCase.Data:
        return data(this.data!);

      case _$ResultCase.Error:
        return error(this.error!);
    }
  }

  $R? match<$R>(
      {$R Function(Data<T>? value)? data,
      $R Function(Error value)? error,
      $R Function(Result<T> value)? otherwise}) {
    switch (_$case) {
      case _$ResultCase.Data:
        if (data != null) return data(this.data!);
        break;

      case _$ResultCase.Error:
        if (error != null) return error(this.error!);
        break;
    }
    return otherwise?.call(this);
  }

  bool get hasData => _$case == _$ResultCase.Data;
  bool get hasError => _$case == _$ResultCase.Error;
}

enum _$ResultCase { Data, Error }

class Either<T> {
  Either._(this._$case, this.result, this.none);

  Either.result(Result<T> result) : this._(_$EitherCase.Result, result, null);

  Either.none(int none) : this._(_$EitherCase.None, null, none);

  final _$EitherCase _$case;

  final Result<T>? result;

  final int? none;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(result) ^
      const DeepCollectionEquality().hash(none) ^
      const DeepCollectionEquality().hash(_$case) ^
      super.hashCode;
  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Either<T> &&
            (identical(other.result, result) ||
                const DeepCollectionEquality().equals(other.result, result)) &&
            (identical(other.none, none) ||
                const DeepCollectionEquality().equals(other.none, none)));
  }

  @override
  String toString() => 'Either(result: $result, none: $none)';
  $R map<$R>($R Function(Result<T> value) result, $R Function(int value) none) {
    switch (_$case) {
      case _$EitherCase.Result:
        return result(this.result!);

      case _$EitherCase.None:
        return none(this.none!);
    }
  }

  $R? match<$R>(
      {$R Function(Result<T> value)? result,
      $R Function(int value)? none,
      $R Function(Either<T> value)? otherwise}) {
    switch (_$case) {
      case _$EitherCase.Result:
        if (result != null) return result(this.result!);
        break;

      case _$EitherCase.None:
        if (none != null) return none(this.none!);
        break;
    }
    return otherwise?.call(this);
  }

  bool get hasResult => _$case == _$EitherCase.Result;
  bool get hasNone => _$case == _$EitherCase.None;
}

enum _$EitherCase { Result, None }
