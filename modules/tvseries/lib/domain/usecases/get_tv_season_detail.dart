import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetTvSeasonDetail {
  final TvRepository repository;

  const GetTvSeasonDetail({
    required this.repository
  });

  Future<Either<Failure, TvSeasonDetail>> execute(String tvId, String seasonId)
  => repository.getSeasonDetailTvSeries(tvId, seasonId);
}