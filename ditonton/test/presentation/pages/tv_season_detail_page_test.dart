import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/data/models/seasons.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_season_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_season_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_season_detail_page_test.mocks.dart';

@GenerateMocks([TvSeasonDetailNotifier])
void main() {
  late MockTvSeasonDetailNotifier mockNotifier;
  setUp(() {
    mockNotifier = MockTvSeasonDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TvSeasonDetailNotifier>.value(
          value: mockNotifier,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when TV series not added to watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.tvSeasonDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvSeasonDetail).thenReturn(testSeasonDetail);

        final seasonDetailTitle = find.text("Test Title - Season 1");

        await tester.pumpWidget(_makeTestableWidget(
            TvSeasonDetailPage(
                tvSeriesName: "Test Title",
                defaultPoster: "/test.jpg",
                tvId: 1,
                seasonId: 1
            )
        ));

        expect(seasonDetailTitle, findsOneWidget);
      });

  testWidgets(
      'Should display progressbar loading whenn TV series is loading',
          (WidgetTester tester) async {
        when(mockNotifier.tvSeasonDetailState).thenReturn(RequestState.Loading);

        final progressIndicator = find.byType(CircularProgressIndicator);

        await tester.pumpWidget(_makeTestableWidget(
            TvSeasonDetailPage(
                tvSeriesName: "Test Title",
                defaultPoster: "/test.jpg",
                tvId: 1,
                seasonId: 1
            )
        ));

        expect(progressIndicator, findsOneWidget);
      });
}