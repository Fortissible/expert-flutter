class TestSingleton {
  static TestSingleton? _instance;

  TestSingleton._internal(){
    _instance = this;
  }

  factory TestSingleton() => _instance ?? TestSingleton._internal();
}