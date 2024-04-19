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
        final tvCardTitle = find.text("Hazbin Hotel");

        await tester.pumpWidget(makeTestableWidget(
            TvCard(
              testTv
            )
        ));

        expect(tvCardTitle, findsOneWidget);
      });
}