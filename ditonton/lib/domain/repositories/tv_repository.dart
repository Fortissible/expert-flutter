import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

abstract class TvRepository {
  Future<Either<Failure,List<Tv>>> getNowPlayingTvSeries();
  Future<Either<Failure,List<Tv>>> getTopRatedTvSeries();
  Future<Either<Failure,List<Tv>>> getPopularTvSeries();
  Future<Either<Failure,TvDetail>> getDetailTvSeries(String tvId);
  Future<Either<Failure,List<Tv>>> searchTvSeries(String query);
  Future<Either<Failure,List<Tv>>> getTvRecommendation(String tvId);

  Future<Either<Failure,String>> insertWatchlistTv(TvDetail tv);
  Future<Either<Failure,String>> removeWatchlistTv(TvDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTv();
}
