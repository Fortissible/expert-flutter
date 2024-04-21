import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:mockito/mockito.dart';

class MockMovieListBloc
    extends MockBloc<MovieListEvent, MovieListState>
    implements MovieListBloc {}

class MovieListStateFake extends Fake implements MovieListState {}

class MovieListEventFake extends Fake implements MovieListEvent {}

class MockMoviePopularBloc
    extends MockBloc<MoviePopularEvent, MoviePopularState>
    implements MoviePopularBloc {}

class MoviePopularStateFake extends Fake implements MoviePopularState {}

class MoviePopularEventFake extends Fake implements MoviePopularEvent {}

class MockMovieTopRatedBloc
    extends MockBloc<MovieTopRatedEvent, MovieTopRatedState>
    implements MovieTopRatedBloc {}

class MovieTopRatedStateFake extends Fake implements MovieTopRatedState {}

class MovieTopRatedEventFake extends Fake implements MovieTopRatedEvent {}

class MockMovieDetailBloc
    extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}