import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tvseries/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_fake_bloc.dart';

void main() {
  late MockTvDetailBloc mockBloc;
  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  setUpAll((){
    registerFallbackValue(TvDetailStateFake());
    registerFallbackValue(TvDetailEventFake());
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TvDetailBloc>.value(
            value: mockBloc,
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
        when(() => mockBloc.state).thenReturn(
            TvDetailState(
                tvRecommendations: const [],
                tvSeasons: null
            ).copyWith(
              tvDetailState: RequestState.Loading
            )
        );

        final progressBarLoading = find.byType(CircularProgressIndicator);

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 94954)));

        expect(progressBarLoading, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display add icon when TV series not added to watchlist',
          (WidgetTester tester) async {
            when(() => mockBloc.state).thenReturn(
                TvDetailState(
                    tvRecommendations: const [],
                    tvSeasons: null
                ).copyWith(
                  tvDetailState: RequestState.Loaded,
                  tvDetail: testTvDetail,
                  tvRecommendationState: RequestState.Loaded,
                  tvRecommendations: <Tv>[
                    testTv
                  ],
                  tvWatchlistStatus: false,
                  tvSeasons: testSeason
                )
            );

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 94954)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should dispay check icon when TV series is added to watchlist',
          (WidgetTester tester) async {
            when(() => mockBloc.state).thenReturn(
                TvDetailState(
                    tvRecommendations: const [],
                    tvSeasons: null
                ).copyWith(
                    tvDetailState: RequestState.Loaded,
                    tvDetail: testTvDetail,
                    tvRecommendationState: RequestState.Loaded,
                    tvRecommendations: <Tv>[],
                    tvWatchlistStatus: true,
                    tvSeasons: testSeason
                )
            );

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 94954)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
            whenListen(
              mockBloc,
              Stream.fromIterable([
                TvDetailState(
                    tvDetailState: RequestState.Loaded,
                    tvDetail: testTvDetail,
                    tvRecommendationState: RequestState.Empty,
                    tvRecommendations: const <Tv>[],
                    tvWatchlistStatus: true,
                    tvWatchlistMsg: 'Added to TV Series Watchlist',
                    tvSeasons: testSeason
                )
              ]),
              initialState: TvDetailState(
                  tvDetailState: RequestState.Loaded,
                  tvDetail: testTvDetail,
                  tvRecommendationState: RequestState.Empty,
                  tvRecommendations: const <Tv>[],
                  tvSeasons: testSeason
              ),
            );

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 94954)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton, warnIfMissed: false);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to TV Series Watchlist'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
            whenListen(
              mockBloc,
              Stream.fromIterable([
                TvDetailState(
                    tvDetailState: RequestState.Loaded,
                    tvDetail: testTvDetail,
                    tvRecommendationState: RequestState.Empty,
                    tvRecommendations: const <Tv>[],
                    tvWatchlistStatus: false,
                    tvWatchlistMsg: 'Failed',
                    tvSeasons: testSeason
                )
              ]),
              initialState: TvDetailState(
                  tvDetailState: RequestState.Loaded,
                  tvDetail: testTvDetail,
                  tvRecommendationState: RequestState.Empty,
                  tvRecommendations: const <Tv>[],
                  tvWatchlistStatus: false,
                  tvWatchlistMsg: '',
                  tvSeasons: testSeason
              ),
            );

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 94954)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });
}