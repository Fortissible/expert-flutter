import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetTvRecommendation {
  final TvRepository repository;

  const GetTvRecommendation({
    required this.repository
  });

  Future<Either<Failure, List<Tv>>> execute(String tvId) async =>
      repository.getTvRecommendation(tvId);
}