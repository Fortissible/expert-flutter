import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_popular_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main(){
  late MoviePopularBloc bloc;
  late MockGetPopularMovies mockGetPopularMovie;

  setUp(() {
    mockGetPopularMovie = MockGetPopularMovies();
    bloc = MoviePopularBloc(
        mockGetPopularMovie
    );
  });

  void arrangeUseCase({bool isSuccess = true, bool isEmpty = false}){
    when(mockGetPopularMovie.execute())
        .thenAnswer((_) async => isSuccess
        ? isEmpty
        ? const Right([])
        : Right(testMovieList)
        : const Left(ServerFailure('Server Failure')));
  }

  group("Popular TV Series",(){
    test("Initial state should be request.empty", (){
      expect(bloc.state.moviePopularState, RequestState.Empty);
    });

    blocTest<MoviePopularBloc, MoviePopularState>("When fetching from remote, "
        "use case should be executed",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMoviesPopular()),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetPopularMovie.execute());
        }
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
        "State should Should emit [Loading, Loaded] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMoviesPopular()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          MoviePopularState().copyWith(
              moviePopularState: RequestState.Loading
          ),
          MoviePopularState().copyWith(
              moviePopularState: RequestState.Loaded,
              moviePopular: testMovieList
          ),
        ],
        verify: (bloc){
          verify(mockGetPopularMovie.execute());
        }
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
        "State should Should emit [Loading, Error] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMoviesPopular()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          MoviePopularState().copyWith(
              moviePopularState: RequestState.Loading
          ),
          MoviePopularState().copyWith(
              moviePopularState: RequestState.Error,
              moviePopularMsg: 'Server Failure'
          ),
        ],
        verify: (bloc){
          verify(mockGetPopularMovie.execute());
        }
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
        "State should Should emit [Loading, Empty] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: true, isEmpty: true);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMoviesPopular()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          MoviePopularState().copyWith(
              moviePopularState: RequestState.Loading
          ),
          MoviePopularState().copyWith(
              moviePopularState: RequestState.Empty,
              moviePopular: []
          ),
        ],
        verify: (bloc){
          verify(mockGetPopularMovie.execute());
        }
    );
  });
}