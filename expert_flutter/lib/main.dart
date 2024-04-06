import 'package:expert_flutter/presentation/pages/home.dart';
import 'package:expert_flutter/presentation/provider/cat_notifier.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'data/repositories/cat_repository.dart';
import 'design_pattern/behavioral_pattern/template_pattern.dart';
import 'design_pattern/creational_pattern/builder_pattern.dart';
import 'design_pattern/creational_pattern/singleton_pattern.dart';
import 'design_pattern/structural_pattern/adapter_pattern.dart';
import 'design_pattern/structural_pattern/facade_pattern.dart';
import 'di/locator.dart' as di;

void main() {
  // CREATIONAL PATTERN - SINGLETON
  final obj = TestSingleton();
  final otherObj = TestSingleton();

  print(obj == otherObj); // true
  print(obj.hashCode);
  print(otherObj.hashCode);

  // CREATIONAL PATTERN - BUILDER NORMAL
  final ayamGepreg = AyamGeprek(
    Type.dada,
    null,
    jmlCabai: 1
  );

  // CREATIONAL PATTERN - BUILDER
  final bebekGorengBuilder = BebekGorengBuilder(Type.paha)
    ..extraNasi = true
    ..sambal = Sambal.bawang;

  final bebekGoreng = BebekGoreng(bebekGorengBuilder);

  // CREATIONAL PATTERN - BUILDER COPY WITH
  final ikanGoreng = IkanGoreng(type: Type.paha).copyWith(
    notes: 'Minta tambah kol',
    sambal: Sambal.korek,
    jmlCabai: 3,
  );

  // STRUCTURAL PATTERN - FACADE
  final repository = DataRepository();
  repository.getData(isOnline: true);

  // STRUCTURAL PATTERN - ADAPTER
  final googleSDKAuthtication = GoogleSDKAuthentication();
  final githubAuthenticationAdapter =
  GitHubAuthenticationAdapter('abcd-efgh', 'read');

  authenticateApps(googleSDKAuthtication);        // Authenticated!
  authenticateApps(githubAuthenticationAdapter);  // Authenticated!

  // BEHAVIORAL PATTERN - TEMPLATE
  final koiPepet = Koi(name: "Pepet", age: 5);
  final catSapi = Cat(name: "Sapi", age: 7);

  // BEHAVIORAL PATTERN - OBSERVER
  // READ observer_pattern.dart

  // CLEAN ARCHITECTURE PROJECT EXAMPLE :
  // https://github.com/dicodingacademy/a199-flutter-expert-project
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => di.locator<CatNotifier>(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

String detectTriangle(num sideA, num sideB, num sideC){
  List<num> sides = [sideA, sideB, sideC];
  sides.sort();

  for (var element in sides) {
    if (element < 1) {
      throw Exception("Not valid sides");
    }
  }

  if (sides[0] + sides[1] <= sides[2]){
    throw Exception("Inequality triangle theorem");
  }

  if (sides[0] == sides[1] && sides[0] == sides[2]){
    return "Segitiga Sama Sisi";
  } else if (sides[0] == sides[1] || sides[1] == sides[2]){
    return "Segitiga Sama Kaki";
  } else {
    return "Segitiga Sembarang";
  }
}