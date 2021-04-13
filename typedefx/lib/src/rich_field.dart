abstract class RichField<T> {
  const RichField();

  T defaultValue() => throw UnimplementedError();

  String? validate(T value) => throw UnimplementedError();

  T proxy(T value) => throw UnimplementedError();

  String display(T value) => throw UnimplementedError();
}
