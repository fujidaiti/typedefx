class Typedefx {
  const Typedefx._();
}

class Record extends Typedefx {
  const Record._() : super._();
}

class Cases extends Typedefx {
  const Cases._() : super._();
}

class Composite extends Typedefx {
  const Composite._() : super._();
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
const cases = Cases._();
const composite = Composite._();
const spread = Spread._();
const omit = Omit._();
