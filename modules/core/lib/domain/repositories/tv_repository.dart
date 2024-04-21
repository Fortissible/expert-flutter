import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

abstract class TvRepository {
  Future<Either<Failure,List<Tv>>> getNowPlayingTvSeries();
  Future<Either<Failure,List<Tv>>> getTopRatedTvSeries();
  Future<Either<Failure,List<Tv>>> getPopularTvSeries();
  Future<Either<Failure,TvDetail>> getDetailTvSeries(String tvId);
  Future<Either<Failure,TvSeasonDetail>> getSeasonDetailTvSeries(String tvId, String seasonId);
  Future<Either<Failure,List<Tv>>> searchTvSeries(String query);
  Future<Either<Failure,List<Tv>>> getTvRecommendation(String tvId);

  Future<Either<Failure,String>> insertWatchlistTv(TvDetail tv);
  Future<Either<Failure,String>> removeWatchlistTv(TvDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTv();
}
