import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tvseries/tvseries.dart';

class MockTvListBloc
    extends MockBloc<TvListEvent, TvListState>
    implements TvListBloc {}

class TvListStateFake extends Fake implements TvListState {}

class TvListEventFake extends Fake implements TvListEvent {}

class MockTvDetailBloc
    extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class TvDetailStateFake extends Fake implements TvDetailState {}

class TvDetailEventFake extends Fake implements TvDetailEvent {}

class MockTvSeasonBloc
    extends MockBloc<TvSeasonEvent, TvSeasonState>
    implements TvSeasonBloc {}

class TvSeasonStateFake extends Fake implements TvSeasonState {}

class TvSeasonEventFake extends Fake implements TvSeasonEvent {}