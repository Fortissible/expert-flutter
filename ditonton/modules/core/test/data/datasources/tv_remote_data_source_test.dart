import 'dart:convert';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TvRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  setUp(() {
    mockDio = MockDio();
    dataSource = TvRemoteDataSourceImpl(dio: mockDio);
  });

  group('get Now Playing TV Series', () {
    final testTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_now_playing.json')))
        .results;

    test('should return list of TV Model when the response code is 200',
            () async {
          // arrange
          when(mockDio
              .get('$BASE_URL/tv/on_the_air?$API_KEY'))
              .thenAnswer((_) async =>
              Response(
                  requestOptions: RequestOptions(),
                  data: jsonDecode(readJson('dummy_data/tv_now_playing.json')),
                  statusCode: 200
              ));
          // act
          final result = await dataSource.getNowPlayingTvSeries();
          // assert
          expect(result, equals(testTvList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockDio
              .get('$BASE_URL/tv/on_the_air?$API_KEY'))
              .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(),
              data: 'Not Found',
              statusCode: 404
          ));
          // act
          final call = dataSource.getNowPlayingTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Popular TV Series', () {
    final testTvList =
        TvResponse.fromJson(json.decode(readJson('dummy_data/tv_popular.json')))
            .results;

    test('should return list of tv series when response is success (200)',
            () async {
          // arrange
          when(mockDio.get('$BASE_URL/tv/popular?$API_KEY'))
              .thenAnswer((_) async =>
              Response(
                  requestOptions: RequestOptions(),
                  data: jsonDecode(readJson('dummy_data/tv_popular.json')),
                  statusCode: 200
              ));
          // act
          final result = await dataSource.getPopularTvSeries();
          // assert
          expect(result, testTvList);
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockDio.get('$BASE_URL/tv/popular?$API_KEY'))
              .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(),
              data: 'Not Found',
              statusCode: 404
          ));
          // act
          final call = dataSource.getPopularTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Top Rated TV Series', () {
    final testTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_top_rated.json')))
        .results;

    test('should return list of tv series when response code is 200 ', () async {
      // arrange
      when(mockDio.get('$BASE_URL/tv/top_rated?$API_KEY'))
          .thenAnswer((_) async =>
          Response(
              requestOptions: RequestOptions(),
              data: jsonDecode(readJson('dummy_data/tv_top_rated.json')),
              statusCode: 200
          ));
      // act
      final result = await dataSource.getTopRatedTvSeries();
      // assert
      expect(result, testTvList);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockDio.get('$BASE_URL/tv/top_rated?$API_KEY'))
              .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(),
              data: 'Not Found',
              statusCode: 404
          ));
          // act
          final call = dataSource.getTopRatedTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get TV Series detail', () {
    final testId = 1.toString();
    final testTvDetail = TvDetailModel.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockDio.get('$BASE_URL/tv/$testId?$API_KEY'))
          .thenAnswer((_) async =>
          Response(
              requestOptions: RequestOptions(),
              data: jsonDecode(readJson('dummy_data/tv_detail.json')),
              statusCode: 200
          ));
      // act
      final result = await dataSource.getDetailTvSeries(testId);
      // assert
      expect(result, equals(testTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockDio.get('$BASE_URL/tv/$testId?$API_KEY'))
              .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(),
              data: 'Not Found',
              statusCode: 404
          ));
          // act
          final call = dataSource.getDetailTvSeries(testId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get TV Series recommendations', () {
    final testTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_recommendations.json')))
        .results;
    final testId = 1.toString();

    test('should return list of TV Model when the response code is 200',
            () async {
          // arrange
          when(mockDio
              .get('$BASE_URL/tv/$testId/recommendations?$API_KEY'))
              .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(),
              data: jsonDecode(readJson('dummy_data/tv_recommendations.json')),
              statusCode: 200
          ));
          // act
          final result = await dataSource.getTvRecommendation(testId);
          // assert
          expect(result, equals(testTvList));
        });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockDio
              .get('$BASE_URL/tv/$testId/recommendations?$API_KEY'))
              .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(),
              data: 'Not Found',
              statusCode: 404
          ));
          // act
          final call = dataSource.getTvRecommendation(testId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('search movies', () {
    final tSearchResult = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_search_morty.json')))
        .results;
    const tQuery = 'morty';

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(mockDio
          .get('$BASE_URL/search/tv?$API_KEY&query=$tQuery'))
          .thenAnswer((_) async => Response(
          requestOptions: RequestOptions(),
          data: jsonDecode(readJson('dummy_data/tv_search_morty.json')),
          statusCode: 200
      ));
      // act
      final result = await dataSource.searchTvSeries(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockDio
              .get('$BASE_URL/search/tv?$API_KEY&query=$tQuery'))
              .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(),
              data: 'Not Found',
              statusCode: 404
          ));
          // act
          final call = dataSource.searchTvSeries(tQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });
}