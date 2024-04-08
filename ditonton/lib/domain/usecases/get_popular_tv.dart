import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

import '../../common/failure.dart';
import '../entities/tv.dart';

class GetPopularTv {
  final TvRepository repository;

  const GetPopularTv({
    required this.repository
  });

  Future<Either<Failure, List<Tv>>> execute()
  => repository.getPopularTvSeries();
}