class ToStringMethodTemplate {
  final String label;
  final Iterable<String> fields;

  ToStringMethodTemplate({
    required this.label,
    required this.fields,
  });

  String get displayString =>
      '$label(${fields.map((it) => '${it}: \$${it}').join(', ')})';

  @override
  String toString() {
    return '''
    @override
    String toString() => '$displayString';
    ''';
  }
}
