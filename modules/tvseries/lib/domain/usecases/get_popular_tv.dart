import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetPopularTv {
  final TvRepository repository;

  const GetPopularTv({
    required this.repository
  });

  Future<Either<Failure, List<Tv>>> execute()
  => repository.getPopularTvSeries();
}