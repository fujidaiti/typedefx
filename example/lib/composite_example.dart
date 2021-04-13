class PartA {
  int x;
  String y;
  PartA(this.x, this.y);
}

class PartB {
  int z;
  double w;
  PartB(this.z, this.w);
}

class AB {
  AB(this.x, this.w, this.z, this.y);
  AB.from(PartA a, PartB b) : this(a.x, b.w, b.z, a.y);

  int x;
  String y;
  int z;
  double w;

  PartA toA() => PartA(x, y);
  PartB toB() => PartB(z, w);
}
