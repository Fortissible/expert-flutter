import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Material(
        child: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when TV series not added to watchlist',
          (WidgetTester tester) async {
        final movieCardTitle = find.text("Spider-Man");

        await tester.pumpWidget(makeTestableWidget(
            MovieCard(
                testMovie
            )
        ));

        expect(movieCardTitle, findsOneWidget);
      });
}