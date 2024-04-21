import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Page should display content of about page',
          (WidgetTester tester) async {
        final backIconButton = find.byType(IconButton);
        final contentText = find.text('Ditonton merupakan sebuah '
            'aplikasi katalog film yang dikembangkan oleh '
            'Dicoding Indonesia sebagai contoh proyek '
            'aplikasi untuk kelas Menjadi Flutter Developer Expert.');
        final imageDicoding = find.byType(Image);
        await tester.pumpWidget(makeTestableWidget(const AboutPage()));

        expect(imageDicoding, findsOneWidget);
        expect(contentText, findsOneWidget);
        expect(backIconButton, findsOneWidget);
      });

}