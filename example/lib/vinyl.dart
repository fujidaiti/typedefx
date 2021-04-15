abstract class Animal {
  abstract final String name;
  abstract final int weight;

  void wolk() {}
}

abstract class Dog extends Animal {
  abstract final String nickname;

  void baw() {}
}

class _$Dog extends Dog {
  final String name;
  final int weight;
  final String nickname;

  _$Dog(this.name, this.weight, this.nickname);
}
