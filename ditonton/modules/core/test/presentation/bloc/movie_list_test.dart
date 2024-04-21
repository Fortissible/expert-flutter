import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_list_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies, GetPopularMovies, GetNowPlayingMovies])
void main(){
  late MovieListBloc bloc;

  late MockGetTopRatedMovies mockGetTopRatedMovie;
  late MockGetPopularMovies mockGetPopularMovie;
  late MockGetNowPlayingMovies mockGetNowPlayingMovie;

  setUp(() {
    mockGetNowPlayingMovie = MockGetNowPlayingMovies();
    mockGetPopularMovie = MockGetPopularMovies();
    mockGetTopRatedMovie = MockGetTopRatedMovies();
    bloc = MovieListBloc(
        mockGetNowPlayingMovie,
        mockGetPopularMovie,
        mockGetTopRatedMovie
    );
  });

  void arrangeUseCase({bool isSuccess = true, bool isEmpty = false}){
    when(mockGetNowPlayingMovie.execute())
        .thenAnswer((_) async => isSuccess
        ? isEmpty
        ? const Right([])
        : Right(testMovieList)
        : const Left(ServerFailure('Server Failure')));
    when(mockGetPopularMovie.execute())
        .thenAnswer((_) async => isSuccess
        ? isEmpty
        ? const Right([])
        : Right(testMovieList)
        : const Left(ServerFailure('Server Failure')));
    when(mockGetTopRatedMovie.execute())
        .thenAnswer((_) async => isSuccess
        ? isEmpty
        ? const Right([])
        : Right(testMovieList)
        : const Left(ServerFailure('Server Failure')));
  }

  group("Now playing Movies",(){
    test("Initial state should be request.empty", (){
      expect(bloc.state.movieOnAirState, RequestState.Empty);
    });

    blocTest<MovieListBloc, MovieListState>(
        "When fetching from remote, "
        "use case should be executed",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchOnAirMovie()),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetNowPlayingMovie.execute());
        }
    );

    blocTest<MovieListBloc, MovieListState>(
        "State should Should emit [Loading, Loaded] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchOnAirMovie()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieListState().copyWith(
              movieOnAirState: RequestState.Loading
          ),
          const MovieListState().copyWith(
              movieOnAirState: RequestState.Loaded,
              movieOnAir: testMovieList
          ),
        ],
        verify: (bloc){
          verify(mockGetNowPlayingMovie.execute());
        }
    );

    blocTest<MovieListBloc, MovieListState>(
        "State should Should emit [Loading, Error] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchOnAirMovie()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieListState().copyWith(
              movieOnAirState: RequestState.Loading
          ),
          const MovieListState().copyWith(
              movieOnAirState: RequestState.Error,
              movieOnAirMsg: 'Server Failure'
          ),
        ],
        verify: (bloc){
          verify(mockGetNowPlayingMovie.execute());
        }
    );

    blocTest<MovieListBloc, MovieListState>(
        "State should Should emit [Loading, Empty] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: true, isEmpty: true);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchOnAirMovie()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieListState().copyWith(
              movieOnAirState: RequestState.Loading
          ),
          const MovieListState().copyWith(
              movieOnAirState: RequestState.Empty,
              movieOnAir: []
          ),
        ],
        verify: (bloc){
          verify(mockGetNowPlayingMovie.execute());
        }
    );
  });

  group("Popular TV Series",(){
    test("Initial state should be request.empty", (){
      expect(bloc.state.moviePopularState, RequestState.Empty);
    });

    blocTest<MovieListBloc, MovieListState>("When fetching from remote, "
        "use case should be executed",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPopularMovie()),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetPopularMovie.execute());
        }
    );

    blocTest<MovieListBloc, MovieListState>(
        "State should Should emit [Loading, Loaded] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPopularMovie()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieListState().copyWith(
              moviePopularState: RequestState.Loading
          ),
          const MovieListState().copyWith(
              moviePopularState: RequestState.Loaded,
              moviePopular: testMovieList
          ),
        ],
        verify: (bloc){
          verify(mockGetPopularMovie.execute());
        }
    );

    blocTest<MovieListBloc, MovieListState>(
        "State should Should emit [Loading, Error] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPopularMovie()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieListState().copyWith(
              moviePopularState: RequestState.Loading
          ),
          const MovieListState().copyWith(
              moviePopularState: RequestState.Error,
              moviePopularMsg: 'Server Failure'
          ),
        ],
        verify: (bloc){
          verify(mockGetPopularMovie.execute());
        }
    );

    blocTest<MovieListBloc, MovieListState>(
        "State should Should emit [Loading, Empty] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: true, isEmpty: true);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPopularMovie()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieListState().copyWith(
              moviePopularState: RequestState.Loading
          ),
          const MovieListState().copyWith(
              moviePopularState: RequestState.Empty,
              moviePopular: []
          ),
        ],
        verify: (bloc){
          verify(mockGetPopularMovie.execute());
        }
    );
  });

  group("Top Rated movie Series",(){
    test("Initial state should be request.empty", (){
      expect(bloc.state.movieTopRatedState, RequestState.Empty);
    });

    blocTest<MovieListBloc, MovieListState>("When fetching from remote, "
        "use case should be executed",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTopRatedMovie()),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetTopRatedMovie.execute());
        }
    );

    blocTest<MovieListBloc, MovieListState>(
        "State should Should emit [Loading, Loaded] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTopRatedMovie()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieListState().copyWith(
              movieTopRatedState: RequestState.Loading
          ),
          const MovieListState().copyWith(
              movieTopRatedState: RequestState.Loaded,
              movieTopRated: testMovieList
          ),
        ],
        verify: (bloc){
          verify(mockGetTopRatedMovie.execute());
        }
    );

    blocTest<MovieListBloc, MovieListState>(
        "State should Should emit [Loading, Error] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTopRatedMovie()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieListState().copyWith(
              movieTopRatedState: RequestState.Loading
          ),
          const MovieListState().copyWith(
              movieTopRatedState: RequestState.Error,
              movieTopRatedMsg: 'Server Failure'
          ),
        ],
        verify: (bloc){
          verify(mockGetTopRatedMovie.execute());
        }
    );

    blocTest<MovieListBloc, MovieListState>(
        "State should Should emit [Loading, Empty] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: true, isEmpty: true);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTopRatedMovie()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieListState().copyWith(
              movieTopRatedState: RequestState.Loading
          ),
          const MovieListState().copyWith(
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