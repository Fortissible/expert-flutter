import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_fake_bloc.dart';

void main() {
  late MockMovieTopRatedBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieTopRatedBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieTopRatedBloc>.value(
          value: mockBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(
            MovieTopRatedState().copyWith(
                movieTopRatedState: RequestState.Loading,
            )
        );

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(
            MovieTopRatedState().copyWith(
              movieTopRatedState: RequestState.Loaded,
              movieTopRated: testMovieList
            )
        );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(
            MovieTopRatedState().copyWith(
                movieTopRatedState: RequestState.Error,
                movieTopRatedMsg: 'Error Message'
            )
        );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
