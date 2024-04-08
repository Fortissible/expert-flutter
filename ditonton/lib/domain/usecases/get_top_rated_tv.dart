import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetTopRatedTv {
  final TvRepository repository;

  const GetTopRatedTv({
    required this.repository
  });

  Future<Either<Failure, List<Tv>>> execute()
    => repository.getTopRatedTvSeries();
}