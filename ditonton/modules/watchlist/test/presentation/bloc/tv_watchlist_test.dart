import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/watchlist.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_watchlist_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main(){
  late TvWatchlistBloc bloc;
  late MockGetWatchlistTv mockGetWatchlistTvs;

  setUp((){
    mockGetWatchlistTvs = MockGetWatchlistTv();
    bloc = TvWatchlistBloc(mockGetWatchlistTvs);
  });

  void arrangeUseCase({bool isSuccess = true, bool isEmpty = false}){
    when(mockGetWatchlistTvs.execute())
        .thenAnswer((_) async => isSuccess
        ? isEmpty
        ? const Right([])
        : Right([testTvWatchlist])
        : const Left(DatabaseFailure('DB Failure'))
    );
  }

  group('fetch Tv watchlist', () {
    test('initial state should be empty', () {
      expect(bloc.state.tvWatchlistState, RequestState.Empty);
    });

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        arrangeUseCase();
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvWatchlist()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const TvWatchlistState().copyWith(
            tvWatchlistState: RequestState.Loading
        ),
        const TvWatchlistState().copyWith(
            tvWatchlistState: RequestState.Loaded,
            tvWatchlist: [testTvWatchlist]
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      },
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit [Loading, Error] when data is gotten successfully',
      build: () {
        arrangeUseCase(isSuccess: false);
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvWatchlist()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const TvWatchlistState().copyWith(
            tvWatchlistState: RequestState.Loading
        ),
        const TvWatchlistState().copyWith(
            tvWatchlistState: RequestState.Error,
            tvWatchlistMsg: 'DB Failure'
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      },
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      'Should emit [Loading, Empty] when data is gotten successfully',
      build: () {
        arrangeUseCase(isSuccess: true, isEmpty: true);
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvWatchlist()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const TvWatchlistState().copyWith(
            tvWatchlistState: RequestState.Loading
        ),
        const TvWatchlistState().copyWith(
            tvWatchlistState: RequestState.Empty,
            tvWatchlist: []
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      },
    );
  });
}