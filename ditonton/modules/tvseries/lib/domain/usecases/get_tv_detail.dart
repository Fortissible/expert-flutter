import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetTvDetail {
  final TvRepository repository;

  const GetTvDetail({
    required this.repository
  });

  Future<Either<Failure, TvDetail>> execute(String tvId)
    => repository.getDetailTvSeries(tvId);
}