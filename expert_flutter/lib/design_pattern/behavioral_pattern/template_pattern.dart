abstract class Animal {
  int age;
  String name;
  Animal(
      this.age,
      this.name
      );

  void reproduction();
  void eat();
  void sound();
}

class Cat implements Animal{
  @override
  int age;

  @override
  String name;

  Cat({
    required this.name,
    required this.age
  });

  @override
  void eat() {
    print("$name is eating a salmon");
  }

  @override
  void reproduction() {
    print("$name currently at age $age, and can do reproduction to continue it's bloodline");
  }

  @override
  void sound() {
    print("Meow");
  }

  void doWalk(){
    print("$name can walk");
  }
}

class Koi implements Animal{
  @override
  int age;

  @override
  String name;

  Koi({
    required this.age,
    required this.name
  });

  @override
  void eat() {
    print("$name is eating a pellet");
  }

  @override
  void reproduction() {
    print("$name currently at age $age,and can do reproduction to continue it's bloodline");
  }

  @override
  void sound() {
    print("Blub Blub");
  }

  void doWalk(){
    print("$name can swims");
  }
}