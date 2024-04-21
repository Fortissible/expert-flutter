import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_fake_bloc.dart';

void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  setUpAll((){
    registerFallbackValue(MovieDetailStateFake());
    registerFallbackValue(MovieDetailEventFake());
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(
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
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(
            const MovieDetailState(
            ).copyWith(
              movieDetailState: RequestState.Loaded,
              movieDetail: testMovieDetail,
              movieRecommendationState: RequestState.Loaded,
              movieRecommendations: testMovieList,
              movieWatchlistStatus: false
            )
        );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(
            const MovieDetailState(
            ).copyWith(
                movieDetailState: RequestState.Loaded,
                movieDetail: testMovieDetail,
                movieRecommendationState: RequestState.Loaded,
                movieRecommendations: testMovieList,
                movieWatchlistStatus: true
            )
        );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Should display loading progressbar when load the data from api',
          (WidgetTester tester) async {
            when(() => mockBloc.state).thenReturn(
                const MovieDetailState(
                ).copyWith(
                    movieDetailState: RequestState.Loading,
                )
            );

        final progressBarLoading = find.byType(CircularProgressIndicator);

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

        expect(progressBarLoading, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.fromIterable([
            MovieDetailState(
                movieDetailState: RequestState.Loaded,
                movieDetail: testMovieDetail,
                movieRecommendationState: RequestState.Empty,
                movieRecommendations: const <Movie>[],
                movieWatchlistStatus: true,
                movieWatchlistMsg: 'Added to Movies Watchlist',
            )
          ]),
          initialState: MovieDetailState(
              movieDetailState: RequestState.Loaded,
              movieDetail: testMovieDetail,
              movieRecommendationState: RequestState.Empty,
              movieRecommendations: const <Movie>[],
              movieWatchlistStatus: false,
          ),
        );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Movies Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.fromIterable([
            MovieDetailState(
                movieDetailState: RequestState.Loaded,
                movieDetail: testMovieDetail,
                movieRecommendationState: RequestState.Empty,
                movieRecommendations: const <Movie>[],
                movieWatchlistStatus: false,
                movieWatchlistMsg: 'Failed',
            )
          ]),
          initialState: MovieDetailState(
              movieDetailState: RequestState.Loaded,
              movieDetail: testMovieDetail,
              movieRecommendationState: RequestState.Empty,
              movieRecommendations: const <Movie>[],
              movieWatchlistStatus: false,
              movieWatchlistMsg: '',
          ),
        );

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
