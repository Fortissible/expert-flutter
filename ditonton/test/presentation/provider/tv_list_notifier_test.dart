import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTv, GetPopularTv, GetNowPlayingTv])
void main(){
  late TvListNotifier provider;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetNowPlayingTv mockGetNowPlayingTv;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    provider = TvListNotifier(
        getTopRatedTv: mockGetTopRatedTv,
        getPopularTv: mockGetPopularTv,
        getNowPlayingTv: mockGetNowPlayingTv
    );
  });

  group("Now playing TV Series",(){
    test("Initial state should be request.empty", (){
      expect(provider.nowPlayingState, RequestState.Empty);
    });

    test("When fetching from remote, "
        "use case should be executed", () async {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(testTvList));

      provider.fetchNowPlayingTv();

      verify(mockGetNowPlayingTv.execute());
    });

    test("State should be loading when try "
        "to fetching from remote data source", (){
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(testTvList));

      provider.fetchNowPlayingTv();

      expect(provider.nowPlayingState, RequestState.Loading);
    });

    test("Should change request state and "
        "get the data when data successfully gotten from remote", () async {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Right(testTvList));

      await provider.fetchNowPlayingTv();

      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlayingTv, testTvList);
    });

    test("Should state.error when unsuccessfully "
        "getting data from remote", () async {

      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      await provider.fetchNowPlayingTv();

      expect(provider.nowPlayingState, RequestState.Error);
      expect(provider.nowPlayingErrorMsg, 'Server Failure');
    });
  });

  group("Popular TV Series",(){
    test("Initial state should be request.empty", (){
      expect(provider.popularState, RequestState.Empty);
    });

    test("When fetching from remote, "
        "use case should be executed", () async {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(testTvList));

      provider.fetchPopularTv();

      verify(mockGetPopularTv.execute());
    });

    test("State should be loading when try "
        "to fetching from remote data source", (){
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(testTvList));

      provider.fetchPopularTv();

      expect(provider.popularState, RequestState.Loading);
    });

    test("Should change request state and "
        "get the data when data successfully gotten from remote", () async {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Right(testTvList));

      await provider.fetchPopularTv();

      expect(provider.popularState, RequestState.Loaded);
      expect(provider.popularTv, testTvList);
    });

    test("Should state.error when unsuccessfully "
        "getting data from remote", () async {

      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      await provider.fetchPopularTv();

      expect(provider.popularState, RequestState.Error);
      expect(provider.popularErrorMsg, 'Server Failure');
    });
  });

  group("Top Rated TV Series",(){
    test("Initial state should be request.empty", (){
      expect(provider.topRatedState, RequestState.Empty);
    });

    test("When fetching from remote, "
        "use case should be executed", () async {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(testTvList));

      provider.fetchTopRatedTv();

      verify(mockGetTopRatedTv.execute());
    });

    test("State should be loading when try "
        "to fetching from remote data source", (){
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(testTvList));

      provider.fetchTopRatedTv();

      expect(provider.topRatedState, RequestState.Loading);
    });

    test("Should change request state and "
        "get the data when data successfully gotten from remote", () async {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Right(testTvList));

      await provider.fetchTopRatedTv();

      expect(provider.topRatedState, RequestState.Loaded);
      expect(provider.topRatedTv, testTvList);
    });

    test("Should state.error when unsuccessfully "
        "getting data from remote", () async {

      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      await provider.fetchTopRatedTv();

      expect(provider.topRatedState, RequestState.Error);
      expect(provider.topRatedErrorMsg, 'Server Failure');
    });
  });
}