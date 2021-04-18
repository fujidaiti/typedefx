class ParametersTemplate {
  final Iterable<String> unnamedMandatoryParams;
  final Iterable<String> enclosedParams;
  final bool enclosedParamsAreNamed;

  ParametersTemplate({
    required this.unnamedMandatoryParams,
    required this.enclosedParams,
    required this.enclosedParamsAreNamed,
  });

  @override
  String toString() {
    final params = <String>[];
    if (unnamedMandatoryParams.isNotEmpty) {
      params.add(unnamedMandatoryParams.join(', '));
    }
    if (enclosedParams.isNotEmpty) {
      if (enclosedParamsAreNamed)
        params.add('{${enclosedParams.join(', ')}}');
      else
        params.add('[${enclosedParams.join(', ')}]');
    }
    return params.join(', ');
  }
}
