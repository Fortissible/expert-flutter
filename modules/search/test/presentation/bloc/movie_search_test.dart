import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/presentation/bloc/movie_search/movie_search_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_search_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main(){
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;

  setUp((){
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(mockSearchMovies);
  });

  const testQuery = "morty";


  void arrangeUseCase({bool isSuccess = true, bool isEmpty = false}){
    when(mockSearchMovies.execute(testQuery))
        .thenAnswer((_) async => isSuccess
        ? isEmpty
        ? const Right([])
        : Right(testMovieList)
        : const Left(ServerFailure('Server Failure'))
    );
  }

  group('search tv series', () {
    test('initial state should be empty', () {
      expect(bloc.state.movieSearchState, RequestState.Empty);
    });

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        arrangeUseCase();
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchMovie(query: testQuery)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const MovieSearchState().copyWith(
            movieSearchState: RequestState.Loading
        ),
        const MovieSearchState().copyWith(
            movieSearchState: RequestState.Loaded,
            movieSearch: testMovieList
        ),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(testQuery));
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, Error] when data is gotten successfully',
      build: () {
        arrangeUseCase(isSuccess: false);
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchMovie(query: testQuery)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const MovieSearchState().copyWith(
            movieSearchState: RequestState.Loading
        ),
        const MovieSearchState().copyWith(
            movieSearchState: RequestState.Error,
            movieSearchMsg: 'Server Failure'
        ),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(testQuery));
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, Empty] when data is gotten successfully',
      build: () {
        arrangeUseCase(isSuccess: true, isEmpty: true);
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchMovie(query: testQuery)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const MovieSearchState().copyWith(
            movieSearchState: RequestState.Loading
        ),
        const MovieSearchState().copyWith(
            movieSearchState: RequestState.Empty,
            movieSearch: []
        ),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(testQuery));
      },
    );
  });
}