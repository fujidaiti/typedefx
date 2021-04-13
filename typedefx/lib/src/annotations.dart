class Typedefx {
  const Typedefx._();
}

class Struct extends Typedefx {
  const Struct._() : super._();
}

class Record extends Typedefx {
  const Record._() : super._();
}

class Cases extends Typedefx {
  const Cases._() : super._();
}

class Spread {
  const Spread._();
}

class Omit {
  const Omit._();
}

class Validate {
  const Validate(Function validator);
}

const record = Record._();
const struct = Struct._();
const cases = Cases._();
const spread = Spread._();
const omit = Omit._();
