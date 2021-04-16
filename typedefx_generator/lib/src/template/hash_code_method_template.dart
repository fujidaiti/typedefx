class HashCodeMethodTemplate {
  final Iterable<String> fields;

  HashCodeMethodTemplate({required this.fields});

  Iterable<String> get _deepCollectionEqualities =>
      fields.map((it) => 'const DeepCollectionEquality().hash($it)');

  String get _body => [
        'runtimeType.hashCode',
        ..._deepCollectionEqualities,
      ].join(' ^ ');

  @override
  String toString() {
    return '''
  @override
  int get hashCode => $_body;
    ''';
  }
}
