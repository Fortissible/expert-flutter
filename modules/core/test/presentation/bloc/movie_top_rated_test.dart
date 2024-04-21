import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_top_rated_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main(){
  late MovieTopRatedBloc bloc;

  late MockGetTopRatedMovies mockGetTopRatedMovie;

  setUp(() {
    mockGetTopRatedMovie = MockGetTopRatedMovies();
    bloc = MovieTopRatedBloc(
        mockGetTopRatedMovie
    );
  });

  void arrangeUseCase({bool isSuccess = true, bool isEmpty = false}){
    when(mockGetTopRatedMovie.execute())
        .thenAnswer((_) async => isSuccess
        ? isEmpty
        ? const Right([])
        : Right(testMovieList)
        : const Left(ServerFailure('Server Failure')));
  }

  group("Top Rated movie Series",(){
    test("Initial state should be request.empty", (){
      expect(bloc.state.movieTopRatedState, RequestState.Empty);
    });

    blocTest<MovieTopRatedBloc, MovieTopRatedState>("When fetching from remote, "
        "use case should be executed",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMoviesTopRated()),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetTopRatedMovie.execute());
        }
    );

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
        "State should Should emit [Loading, Loaded] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMoviesTopRated()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          MovieTopRatedState().copyWith(
              movieTopRatedState: RequestState.Loading
          ),
          MovieTopRatedState().copyWith(
              movieTopRatedState: RequestState.Loaded,
              movieTopRated: testMovieList
          ),
        ],
        verify: (bloc){
          verify(mockGetTopRatedMovie.execute());
        }
    );

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
        "State should Should emit [Loading, Error] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMoviesTopRated()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          MovieTopRatedState().copyWith(
              movieTopRatedState: RequestState.Loading
          ),
          MovieTopRatedState().copyWith(
              movieTopRatedState: RequestState.Error,
              movieTopRatedMsg: 'Server Failure'
          ),
        ],
        verify: (bloc){
          verify(mockGetTopRatedMovie.execute());
        }
    );

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
        "State should Should emit [Loading, Empty] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: true, isEmpty: true);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMoviesTopRated()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          MovieTopRatedState().copyWith(
              movieTopRatedState: RequestState.Loading
          ),
          MovieTopRatedState().copyWith(
              movieTopRatedState: RequestState.Empty,
              movieTopRated: []
          ),
        ],
        verify: (bloc){
          verify(mockGetTopRatedMovie.execute());
        }
    );
  });
}