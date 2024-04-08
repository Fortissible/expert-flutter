import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetTvRecommendation {
  final TvRepository repository;

  const GetTvRecommendation({
    required this.repository
  });

  Future<Either<Failure, List<Tv>>> execute(String tvId) async =>
      repository.getTvRecommendation(tvId);
}