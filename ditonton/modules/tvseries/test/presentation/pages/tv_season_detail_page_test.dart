import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_fake_bloc.dart';

void main() {
  late MockTvSeasonBloc mockBloc;
  setUp(() {
    mockBloc = MockTvSeasonBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeasonBloc>.value(
          value: mockBloc,
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
        when(()=>mockBloc.state).thenReturn(
          const TvSeasonState().copyWith(
            tvSeasonState: RequestState.Loaded,
            tvSeason: testSeasonDetail
          )
        );

        final seasonDetailTitle = find.text("Test Title - Season 1");

        await tester.pumpWidget(makeTestableWidget(
            const TvSeasonDetailPage(
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
            when(()=>mockBloc.state).thenReturn(
                const TvSeasonState().copyWith(
                    tvSeasonState: RequestState.Loading,
                )
            );

        final progressIndicator = find.byType(CircularProgressIndicator);

        await tester.pumpWidget(makeTestableWidget(
            const TvSeasonDetailPage(
                tvSeriesName: "Test Title",
                defaultPoster: "/test.jpg",
                tvId: 1,
                seasonId: 1
            )
        ));

        expect(progressIndicator, findsOneWidget);
      });
}