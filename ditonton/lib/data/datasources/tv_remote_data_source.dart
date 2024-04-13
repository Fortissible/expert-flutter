import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_model.dart';

import '../models/tv_detail_model.dart';
import '../models/tv_response.dart';
import '../models/tv_season_detail_model.dart';

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getNowPlayingTvSeries();
  Future<List<TvModel>> getTopRatedTvSeries();
  Future<List<TvModel>> getPopularTvSeries();
  Future<TvDetailModel> getDetailTvSeries(String tvId);
  Future<TvSeasonDetailModel> getSeasonDetailTvSeries(String tvId, String seasonId);
  Future<List<TvModel>> searchTvSeries(String query);
  Future<List<TvModel>> getTvRecommendation(String TvId);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  static const ENDPOINT_URL_TV_TOPRATED = "/tv/top_rated";
  static const ENDPOINT_URL_TV_POPULAR = "/tv/popular";
  static const ENDPOINT_URL_TV_ONTHEAIR= "/tv/on_the_air";
  static const ENDPOINT_URL_TV_DETAIL= "/tv";
  static const ENDPOINT_URL_TV_SEASON_DETAIL= "/season";
  static const ENDPOINT_URL_TV_SEARCH = "/search/tv";
  static const ENDPOINT_URL_TV_RECOMMENDATION = "/recommendations";

  final Dio dio;

  TvRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TvModel>> getNowPlayingTvSeries() async {
    final response =
    await dio.get('$BASE_URL$ENDPOINT_URL_TV_ONTHEAIR?$API_KEY');

    if (response.statusCode == 200) {
      return TvResponse.fromJson(response.data).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTvSeries() async {
    final response =
    await dio.get('$BASE_URL$ENDPOINT_URL_TV_POPULAR?$API_KEY');

    if (response.statusCode == 200) {
      return TvResponse.fromJson(response.data).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTvSeries() async {
    final response =
    await dio.get(
        '$BASE_URL$ENDPOINT_URL_TV_TOPRATED?$API_KEY'
    );

    if (response.statusCode == 200) {
      return TvResponse.fromJson(response.data).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailModel> getDetailTvSeries(String tvId) async {
    final response =
    await dio.get(
        '$BASE_URL$ENDPOINT_URL_TV_DETAIL/$tvId?$API_KEY'
    );

    if (response.statusCode == 200) {
      return TvDetailModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeasonDetailModel> getSeasonDetailTvSeries(String tvId, String seasonId) async {
    final response =
    await dio.get(
        '$BASE_URL$ENDPOINT_URL_TV_DETAIL/$tvId$ENDPOINT_URL_TV_SEASON_DETAIL/$seasonId?$API_KEY'
    );

    if (response.statusCode == 200) {
      return TvSeasonDetailModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTvSeries(String query) async {
    final response =
    await dio.get(
        '$BASE_URL$ENDPOINT_URL_TV_SEARCH?$API_KEY&query=$query'
    );

    if (response.statusCode == 200) {
      return TvResponse.fromJson(response.data).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendation(String TvId) async {
    final response =
    await dio.get(
        '$BASE_URL$ENDPOINT_URL_TV_DETAIL/$TvId$ENDPOINT_URL_TV_RECOMMENDATION?$API_KEY'
    );

    if (response.statusCode == 200) {
      return TvResponse.fromJson(response.data).results;
    } else {
      throw ServerException();
    }
  }
}