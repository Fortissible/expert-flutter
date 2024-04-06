enum Type {
  nexus5, nexus9
}

abstract class Handphone {
  late String processor;
  late String battery;
  late String screenSize;

  factory Handphone(Type type) {
    switch (type) {
      case Type.nexus5:
        return HandphoneNexus5();
      case Type.nexus9:
        return HandphoneNexus9();
    }
  }
}

class HandphoneNexus5 implements Handphone {
  @override
  String processor = 'Snapdragon';

  @override
  String battery = '2300 mAh';

  @override
  String screenSize = '4.95 inch';
}

class HandphoneNexus9 implements Handphone {
  @override
  String processor = 'Nvidia Tegra';

  @override
  String battery = '6700 mAh';

  @override
  String screenSize = '8.9 inch';

}
