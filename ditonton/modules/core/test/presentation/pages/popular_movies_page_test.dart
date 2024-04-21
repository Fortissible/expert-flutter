import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_fake_bloc.dart';

void main() {
  late MockMoviePopularBloc mockBloc;

  setUp(() {
    mockBloc = MockMoviePopularBloc();
  });

  setUpAll((){
    registerFallbackValue(MovieListStateFake());
    registerFallbackValue(MovieListEventFake());
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviePopularBloc>.value(
          value: mockBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
        when(()=>mockBloc.state).thenReturn(
            MoviePopularState().copyWith(
                moviePopularState: RequestState.Loading
            )
        );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
        when(()=>mockBloc.state).thenReturn(
            MoviePopularState().copyWith(
                moviePopularState: RequestState.Loaded,
                moviePopular: testMovieList
            )
        );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
        when(()=>mockBloc.state).thenReturn(
            MoviePopularState().copyWith(
                moviePopularState: RequestState.Error,
                moviePopularMsg: 'Error message'
            )
        );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
