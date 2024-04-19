import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_fake_bloc.dart';

void main() {
  late MockTvListBloc mockBloc;

  setUp(() {
    mockBloc = MockTvListBloc();
  });

  setUpAll((){
    registerFallbackValue(TvListStateFake());
    registerFallbackValue(TvListEventFake());
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvListBloc>.value(
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
          TvListState().copyWith(
            tvOnAirState: RequestState.Loading
          )
        );

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(makeTestableWidget(const NowPlayingTvPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(()=>mockBloc.state).thenReturn(
          TvListState().copyWith(
            tvOnAirState: RequestState.Loaded,
            tvOnAir: <Tv>[testTv]
          )
        );

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(makeTestableWidget(const NowPlayingTvPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(()=>mockBloc.state).thenReturn(
            TvListState().copyWith(
                tvOnAirState: RequestState.Error,
                tvOnAirMsg: 'Error message'
            )
        );

        final textFinder = find.byKey(const Key('error_message'));

        await tester.pumpWidget(makeTestableWidget(const NowPlayingTvPage()));

        expect(textFinder, findsOneWidget);
      });
}