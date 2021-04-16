extension When<R> on List<MapEntry<bool, R Function()>> {
  R eval() => this
      .firstWhere(
        (it) => it.key == true,
        orElse: () => throw Exception('Should not be reached'),
      )
      .value();
}

MapEntry<bool, R Function()> when<R>(bool cond, {required R then()}) =>
    MapEntry(cond, then);

extension Let<T> on T {
  R let<R>(R function(T it)) => function(this);
}

extension StringUtils on String {
  String capitalizeFirstLetter() {
    if (length < 2) return this.toUpperCase();
    return this[0].toUpperCase() + this.substring(1);
  }
}
