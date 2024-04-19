import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tv.dart';
import 'package:search/presentation/bloc/tv_search/tv_search_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_search_test.mocks.dart';

@GenerateMocks([SearchTvUsecase])
void main(){
  late TvSearchBloc bloc;
  late MockSearchTvUsecase mockSearchTv;

  setUp((){
    mockSearchTv = MockSearchTvUsecase();
    bloc = TvSearchBloc(mockSearchTv);
  });

  const testQuery = "morty";


  void arrangeUseCase({bool isSuccess = true, bool isEmpty = false}){
    when(mockSearchTv.execute(testQuery))
        .thenAnswer((_) async => isSuccess
        ? isEmpty
          ? const Right([])
          : Right(testTvList)
        : const Left(ServerFailure('Server Failure'))
    );
  }

  group('search tv series', () {
    test('initial state should be empty', () {
      expect(bloc.state.tvSearchState, RequestState.Empty);
    });

    blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        arrangeUseCase();
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchTv(query: testQuery)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const TvSearchState().copyWith(
            tvSearchState: RequestState.Loading
        ),
        const TvSearchState().copyWith(
            tvSearchState: RequestState.Loaded,
            tvSearch: testTvList
        ),
      ],
      verify: (bloc) {
        verify(mockSearchTv.execute(testQuery));
      },
    );

    blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, Error] when data is gotten successfully',
      build: () {
        arrangeUseCase(isSuccess: false);
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchTv(query: testQuery)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const TvSearchState().copyWith(
            tvSearchState: RequestState.Loading
        ),
        const TvSearchState().copyWith(
            tvSearchState: RequestState.Error,
            tvSearchMsg: 'Server Failure'
        ),
      ],
      verify: (bloc) {
        verify(mockSearchTv.execute(testQuery));
      },
    );

    blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, Empty] when data is gotten successfully',
      build: () {
        arrangeUseCase(isSuccess: true, isEmpty: true);
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchTv(query: testQuery)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const TvSearchState().copyWith(
            tvSearchState: RequestState.Loading
        ),
        const TvSearchState().copyWith(
            tvSearchState: RequestState.Empty,
            tvSearch: []
        ),
      ],
      verify: (bloc) {
        verify(mockSearchTv.execute(testQuery));
      },
    );
  });
}