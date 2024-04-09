import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

import '../../common/failure.dart';
import '../repositories/tv_repository.dart';

class GetTvDetail {
  final TvRepository repository;

  const GetTvDetail({
    required this.repository
  });

  Future<Either<Failure, TvDetail>> execute(String tvId)
    => repository.getDetailTvSeries(tvId);
}