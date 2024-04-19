import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/watchlist.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main(){
  late MovieWatchlistBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp((){
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = MovieWatchlistBloc(mockGetWatchlistMovies);
  });

  void arrangeUseCase({bool isSuccess = true, bool isEmpty = false}){
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => isSuccess
        ? isEmpty
        ? const Right([])
        : Right([testWatchlistMovie])
        : const Left(DatabaseFailure('DB Failure'))
    );
  }

  group('fetch movie watchlist', () {
    test('initial state should be empty', () {
      expect(bloc.state.movieWatchlistState, RequestState.Empty);
    });

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        arrangeUseCase();
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieWatchlist()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const MovieWatchlistState().copyWith(
            movieWatchlistState: RequestState.Loading
        ),
        const MovieWatchlistState().copyWith(
            movieWatchlistState: RequestState.Loaded,
            movieWatchlist: [testWatchlistMovie]
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [Loading, Error] when data is gotten successfully',
      build: () {
        arrangeUseCase(isSuccess: false);
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieWatchlist()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const MovieWatchlistState().copyWith(
            movieWatchlistState: RequestState.Loading
        ),
        const MovieWatchlistState().copyWith(
            movieWatchlistState: RequestState.Error,
            movieWatchlistMsg: 'DB Failure'
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [Loading, Empty] when data is gotten successfully',
      build: () {
        arrangeUseCase(isSuccess: true, isEmpty: true);
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieWatchlist()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const MovieWatchlistState().copyWith(
            movieWatchlistState: RequestState.Loading
        ),
        const MovieWatchlistState().copyWith(
            movieWatchlistState: RequestState.Empty,
            movieWatchlist: []
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });
}