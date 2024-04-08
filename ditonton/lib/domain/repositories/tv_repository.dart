import 'package:dartz/dartz.dart';import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

abstract class TvRepository {
  Future<Either<Failure,List<Tv>>> getNowPlayingTvSeries();
  Future<Either<Failure,List<Tv>>> getTopRatedTvSeries();
  Future<Either<Failure,List<Tv>>> getPopularTvSeries();
  Future<Either<Failure,TvDetail>> getDetailTvSeries(String tvId);
  Future<Either<Failure,List<Tv>>> searchTvSeries(String query);
  Future<Either<Failure,List<Tv>>> getTvRecommendation(String tvId);
  //TODO CREATE WATCHLIST FOR TV SERIES
  // Future<Either<Failure,String>> insertTvWatchlist(MovieTable movie);
  // Future<Either<Failure,String>> removeTvWatchlist(MovieTable movie);
  // Future<MovieTable?> getTvById(int id);
  // Future<List<MovieTable>> getWatchlistTv();
}
