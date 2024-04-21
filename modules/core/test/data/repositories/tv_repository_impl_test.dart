import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
        tvLocalDataSource: mockLocalDataSource, 
        tvRemoteDataSource: mockRemoteDataSource
    );
  });

  final testTvModel = TvResponse.fromJson(
      json.decode(readJson('dummy_data/tv_popular.json'))
  ).results.first;

  final tTvModelList = <TvModel>[testTvModel];
  final tTvList = <Tv>[testTvModel.toEntity()];

  group('Now Playing TV Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTvSeries())
              .thenAnswer((_) async => tTvModelList);
          // act
          final result = await repository.getNowPlayingTvSeries();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvSeries());
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTvSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getNowPlayingTvSeries();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvSeries());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTvSeries())
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getNowPlayingTvSeries();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvSeries());
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Popular TV Series', () {
    test('should return TV Series list when call to data source is success',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvSeries())
              .thenAnswer((_) async => tTvModelList);
          // act
          final result = await repository.getPopularTvSeries();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });

    test(
        'should return server failure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getPopularTvSeries();
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return connection failure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvSeries())
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getPopularTvSeries();
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Top Rated TV Series', () {
    test('should return TV Series list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvSeries())
              .thenAnswer((_) async => tTvModelList);
          // act
          final result = await repository.getTopRatedTvSeries();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getTopRatedTvSeries();
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvSeries())
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTopRatedTvSeries();
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Get TV Series Detail', () {
    final tId = 1.toString();
    final tTvModel = TvDetailModel.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json'))
    );

    final tTvDetail = tTvModel.toEntity();

    test(
        'should return TV Series data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getDetailTvSeries(tId))
              .thenAnswer((_) async => tTvModel);
          // act
          final result = await repository.getDetailTvSeries(tId);
          // assert
          verify(mockRemoteDataSource.getDetailTvSeries(tId));
          expect(result, equals(Right(tTvDetail)));
        });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getDetailTvSeries(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getDetailTvSeries(tId);
          // assert
          verify(mockRemoteDataSource.getDetailTvSeries(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getDetailTvSeries(tId))
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getDetailTvSeries(tId);
          // assert
          verify(mockRemoteDataSource.getDetailTvSeries(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Get TV Series Recommendations', () {
    final tTvModelList = <TvModel>[];
    final tId = 1.toString();

    test('should return data (tv list) when the call is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvRecommendation(tId))
              .thenAnswer((_) async => tTvModelList);
          // act
          final result = await repository.getTvRecommendation(tId);
          // assert
          verify(mockRemoteDataSource.getTvRecommendation(tId));
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tTvModelList));
        });

    test(
        'should return server failure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvRecommendation(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvRecommendation(tId);
          // assertbuild runner
          verify(mockRemoteDataSource.getTvRecommendation(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvRecommendation(tId))
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvRecommendation(tId);
          // assert
          verify(mockRemoteDataSource.getTvRecommendation(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Seach TV Series', () {
    const tQuery = 'morty';

    test('should return TV Series list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvSeries(tQuery))
              .thenAnswer((_) async => tTvModelList);
          // act
          final result = await repository.searchTvSeries(tQuery);
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tTvList));
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvSeries(tQuery))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchTvSeries(tQuery);
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvSeries(tQuery))
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.searchTvSeries(tQuery);
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('save TV Series watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.insertWatchlistTv(testTvDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertTvWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.insertWatchlistTv(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove TV Series watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistTv(testTvDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeTvWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistTv(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get TV Series watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist TV Series', () {
    test('should return list of TV Series', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testTvWatchlist]);
    });
  });
}