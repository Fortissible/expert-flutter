import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendation.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendation,
  GetWatchListTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv
])
void main(){
  late TvDetailNotifier provider;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendation mockGetTvRecommendation;
  late MockGetWatchListTvStatus mockGetWatchListTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp((){
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendation = MockGetTvRecommendation();
    mockGetWatchListTvStatus = MockGetWatchListTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    provider = TvDetailNotifier(
        getTvDetail: mockGetTvDetail,
        getTvRecommendation: mockGetTvRecommendation,
        getWatchListStatus: mockGetWatchListTvStatus,
        saveWatchlist: mockSaveWatchlistTv,
        removeWatchlist: mockRemoveWatchlistTv
    );
  });

  final testId = 94954.toString();

  void _arrangeUseCase({bool isSuccess = true}){
    when(mockGetTvDetail.execute(testId))
        .thenAnswer((_) async => isSuccess
          ? Right(testTvDetail)
          : Left(ServerFailure('Server Failure')));
    when(mockGetTvRecommendation.execute(testId))
        .thenAnswer((_) async => isSuccess
          ? Right(testTvList)
          : Left(ServerFailure('Server Failure')));
  }

  group('Get TV Series Detail', () {
    test('should execute usecase when try to fetch detail', () async {
      // arrange
      _arrangeUseCase();
      // act
      await provider.fetchTvDetail(testId);
      // assert
      verify(mockGetTvDetail.execute(testId));
      verify(mockGetTvRecommendation.execute(testId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUseCase();
      // act
      provider.fetchTvDetail(testId);
      // assert
      expect(provider.tvDetailState, RequestState.Loading);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUseCase();
      // act
      await provider.fetchTvDetail(testId);
      // assert
      expect(provider.tvDetailState, RequestState.Loaded);
      expect(provider.tvDetail, testTvDetail);
    });

    test('should change recommendation movies when data is gotten successfully',
            () async {
          // arrange
          _arrangeUseCase();
          // act
          await provider.fetchTvDetail(testId);
          await provider.fetchTvRecommendations(testId);
          // assert
          expect(provider.tvDetailState, RequestState.Loaded);
          expect(provider.tvRecommendations, testTvList);
        });
  });

  group('Get Movie Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUseCase();
      // act
      await provider.fetchTvDetail(testId);
      await provider.fetchTvRecommendations(testId);
      // assert
      verify(mockGetTvRecommendation.execute(testId));
      expect(provider.tvRecommendations, testTvList);
    });

    test('should update recommendation state when data is gotten successfully',
            () async {
          // arrange
          _arrangeUseCase();
          // act
          await provider.fetchTvDetail(testId);
          await provider.fetchTvRecommendations(testId);
          // assert
          expect(provider.tvRecommendationState, RequestState.Loaded);
          expect(provider.tvRecommendations, testTvList);
        });

    test('should update error message when request in successful', () async {
      // arrange
      _arrangeUseCase(isSuccess: false);
      // act
      await provider.fetchTvDetail(testId);
      await provider.fetchTvRecommendations(testId);
      // assert
      expect(provider.tvRecommendationState, RequestState.Error);
      expect(provider.tvRecommendationsErrorMsg, 'Server Failure');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchListTvStatus.execute(int.parse(testId))).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(int.parse(testId));
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchListTvStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTvDetail);
      // assert
      verify(mockSaveWatchlistTv.execute(testTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchListTvStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testTvDetail);
      // assert
      verify(mockRemoveWatchlistTv.execute(testTvDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchListTvStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTvDetail);
      // assert
      verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListTvStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testTvDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      _arrangeUseCase(isSuccess: false);
      // act
      await provider.fetchTvDetail(testId);
      // assert
      expect(provider.tvDetailState, RequestState.Error);
      expect(provider.tvDetailErrorMsg, 'Server Failure');
    });
  });
}