// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:expert_flutter/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Detect the triangle", (){
    test("should throw error when the side is less than 1", (){
      expect(() => detectTriangle(-1,2,2), throwsA(isA<Exception>()));
    });

    test("should return 'Segitiga Sama Sisi' when all the sides equal",(){
      expect(detectTriangle(1, 1, 1), "Segitiga Sama Sisi");
      expect(detectTriangle(8, 5, 5), isNot("Segitiga Sama Sisi"));
      expect(detectTriangle(5, 2, 6), isNot("Segitiga Sama Sisi"));
    });

    test("should return 'Segitiga Sama Sisi' when all the sides equal",(){
      expect(detectTriangle(7, 12, 12), "Segitiga Sama Kaki");
      expect(detectTriangle(1, 1, 1), isNot("Segitiga Sama Kaki"));
      expect(detectTriangle(5, 3, 6), isNot("Segitiga Sama Kaki"));
    });

    test("should return 'Segitiga Sama Sisi' when all the sides equal",(){
      expect(detectTriangle(6, 2, 5), "Segitiga Sembarang");
      expect(detectTriangle(1, 1, 1), isNot("Segitiga Sembarang"));
      expect(detectTriangle(6, 6, 11), isNot("Segitiga Sembarang"));
    });

    test('Should throw error when side a + b <= c', () {
      expect(() => detectTriangle(4, 1, 2), throwsA(isA<Exception>()));
      expect(() => detectTriangle(5, 1, 3), throwsA(isA<Exception>()));
      expect(() => detectTriangle(1, 1, 2), throwsA(isA<Exception>()));
    });
  });
}
