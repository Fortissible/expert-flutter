import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/data/models/seasons.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_season_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier])
void main() {
  late MockTvDetailNotifier mockNotifier;
  setUp(() {
    mockNotifier = MockTvDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<TvDetailNotifier>.value(
            value: mockNotifier,
          ),
        ],
        child: MaterialApp(
          home: Material(
            child: body,
          ),
        ),
    );
  }

  testWidgets(
      'Should display loading progressbar when load the data from api',
          (WidgetTester tester) async {
        when(mockNotifier.tvDetailState).thenReturn(RequestState.Loading);

        final progressBarLoading = find.byType(CircularProgressIndicator);

        await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 94954)));

        expect(progressBarLoading, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display add icon when TV series not added to watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.tvDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvDetail).thenReturn(testTvDetail);
        when(mockNotifier.tvRecommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Tv>[
          testTv
        ]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.seasons).thenReturn(
            testSeason
        );

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 94954)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should dispay check icon when TV series is added to watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.tvDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvDetail).thenReturn(testTvDetail);
        when(mockNotifier.tvRecommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(true);
        when(mockNotifier.seasons).thenReturn(
            testSeason
        );

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 94954)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.tvDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvDetail).thenReturn(testTvDetail);
        when(mockNotifier.tvRecommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.watchlistMessage).thenReturn('Added to TV Series Watchlist');
        when(mockNotifier.seasons).thenReturn(
            testSeason
        );

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 94954)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to TV Series Watchlist'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        when(mockNotifier.tvDetailState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvDetail).thenReturn(testTvDetail);
        when(mockNotifier.tvRecommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.watchlistMessage).thenReturn('Failed');
        when(mockNotifier.seasons).thenReturn(
            testSeason
        );

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 94954)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });
}