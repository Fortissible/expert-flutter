import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_list_test.mocks.dart';

@GenerateMocks([GetTopRatedTv, GetPopularTv, GetNowPlayingTv])
void main(){
  late TvListBloc bloc;

  late MockGetTopRatedTv mockGetTopRatedTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetNowPlayingTv mockGetNowPlayingTv;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    bloc = TvListBloc(
        mockGetNowPlayingTv,
        mockGetPopularTv,
        mockGetTopRatedTv
    );
  });

  void arrangeUseCase({bool isSuccess = true, bool isEmpty = false}){
    when(mockGetNowPlayingTv.execute())
        .thenAnswer((_) async => isSuccess
        ? isEmpty
          ? const Right([])
          : Right(testTvList)
        : const Left(ServerFailure('Server Failure')));
    when(mockGetPopularTv.execute())
        .thenAnswer((_) async => isSuccess
        ? isEmpty
          ? const Right([])
          : Right(testTvList)
        : const Left(ServerFailure('Server Failure')));
    when(mockGetTopRatedTv.execute())
        .thenAnswer((_) async => isSuccess
        ? isEmpty
          ? const Right([])
          : Right(testTvList)
        : const Left(ServerFailure('Server Failure')));
  }

  group("Now playing TV Series",(){
    test("Initial state should be request.empty", (){
      expect(bloc.state.tvOnAirState, RequestState.Empty);
    });

    blocTest<TvListBloc, TvListState>("When fetching from remote, "
        "use case should be executed",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchOnAirTv()),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetNowPlayingTv.execute());
        }
    );

    blocTest<TvListBloc, TvListState>(
        "State should Should emit [Loading, Loaded] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchOnAirTv()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          TvListState().copyWith(
              tvOnAirState: RequestState.Loading
          ),
          TvListState().copyWith(
              tvOnAirState: RequestState.Loaded,
              tvOnAir: testTvList
          ),
        ],
        verify: (bloc){
          verify(mockGetNowPlayingTv.execute());
        }
    );

    blocTest<TvListBloc, TvListState>(
        "State should Should emit [Loading, Error] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchOnAirTv()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          TvListState().copyWith(
              tvOnAirState: RequestState.Loading
          ),
          TvListState().copyWith(
              tvOnAirState: RequestState.Error,
              tvOnAirMsg: 'Server Failure'
          ),
        ],
        verify: (bloc){
          verify(mockGetNowPlayingTv.execute());
        }
    );

    blocTest<TvListBloc, TvListState>(
        "State should Should emit [Loading, Empty] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: true, isEmpty: true);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchOnAirTv()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          TvListState().copyWith(
              tvOnAirState: RequestState.Loading
          ),
          TvListState().copyWith(
              tvOnAirState: RequestState.Empty,
              tvOnAir: []
          ),
        ],
        verify: (bloc){
          verify(mockGetNowPlayingTv.execute());
        }
    );
  });

  group("Popular TV Series",(){
    test("Initial state should be request.empty", (){
      expect(bloc.state.tvPopularState, RequestState.Empty);
    });

    blocTest<TvListBloc, TvListState>("When fetching from remote, "
        "use case should be executed",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPopularTv()),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetPopularTv.execute());
        }
    );

    blocTest<TvListBloc, TvListState>(
        "State should Should emit [Loading, Loaded] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPopularTv()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          TvListState().copyWith(
              tvPopularState: RequestState.Loading
          ),
          TvListState().copyWith(
              tvPopularState: RequestState.Loaded,
              tvPopular: testTvList
          ),
        ],
        verify: (bloc){
          verify(mockGetPopularTv.execute());
        }
    );

    blocTest<TvListBloc, TvListState>(
        "State should Should emit [Loading, Error] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPopularTv()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          TvListState().copyWith(
              tvPopularState: RequestState.Loading
          ),
          TvListState().copyWith(
              tvPopularState: RequestState.Error,
              tvPopularMsg: 'Server Failure'
          ),
        ],
        verify: (bloc){
          verify(mockGetPopularTv.execute());
        }
    );

    blocTest<TvListBloc, TvListState>(
        "State should Should emit [Loading, Empty] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: true, isEmpty: true);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPopularTv()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          TvListState().copyWith(
              tvPopularState: RequestState.Loading
          ),
          TvListState().copyWith(
              tvPopularState: RequestState.Empty,
              tvPopular: []
          ),
        ],
        verify: (bloc){
          verify(mockGetPopularTv.execute());
        }
    );
  });

  group("Top Rated TV Series",(){
    test("Initial state should be request.empty", (){
      expect(bloc.state.tvTopRatedState, RequestState.Empty);
    });

    blocTest<TvListBloc, TvListState>("When fetching from remote, "
        "use case should be executed",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTopRatedTv()),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetTopRatedTv.execute());
        }
    );

    blocTest<TvListBloc, TvListState>(
        "State should Should emit [Loading, Loaded] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTopRatedTv()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          TvListState().copyWith(
              tvTopRatedState: RequestState.Loading
          ),
          TvListState().copyWith(
              tvTopRatedState: RequestState.Loaded,
              tvTopRated: testTvList
          ),
        ],
        verify: (bloc){
          verify(mockGetTopRatedTv.execute());
        }
    );

    blocTest<TvListBloc, TvListState>(
        "State should Should emit [Loading, Error] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTopRatedTv()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          TvListState().copyWith(
              tvTopRatedState: RequestState.Loading
          ),
          TvListState().copyWith(
              tvTopRatedState: RequestState.Error,
              tvTopRatedMsg: 'Server Failure'
          ),
        ],
        verify: (bloc){
          verify(mockGetTopRatedTv.execute());
        }
    );

    blocTest<TvListBloc, TvListState>(
        "State should Should emit [Loading, Empty] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: true, isEmpty: true);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTopRatedTv()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          TvListState().copyWith(
              tvTopRatedState: RequestState.Loading
          ),
          TvListState().copyWith(
              tvTopRatedState: RequestState.Empty,
              tvTopRated: []
          ),
        ],
        verify: (bloc){
          verify(mockGetTopRatedTv.execute());
        }
    );
  });
}