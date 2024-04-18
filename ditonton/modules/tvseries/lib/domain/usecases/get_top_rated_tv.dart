import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetTopRatedTv {
  final TvRepository repository;

  const GetTopRatedTv({
    required this.repository
  });

  Future<Either<Failure, List<Tv>>> execute()
    => repository.getTopRatedTvSeries();
}