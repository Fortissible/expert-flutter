import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_season_detail.dart';

import '../../common/failure.dart';
import '../repositories/tv_repository.dart';

class GetTvSeasonDetail {
  final TvRepository repository;

  const GetTvSeasonDetail({
    required this.repository
  });

  Future<Either<Failure, TvSeasonDetail>> execute(String tvId, String seasonId)
  => repository.getSeasonDetailTvSeries(tvId, seasonId);
}