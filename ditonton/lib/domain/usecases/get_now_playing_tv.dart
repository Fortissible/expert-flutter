import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

import '../../common/failure.dart';
import '../entities/tv.dart';

class GetNowPlayingTv {
  final TvRepository repository;

  const GetNowPlayingTv({
    required this.repository
  });

  Future<Either<Failure, List<Tv>>> execute()
    => repository.getNowPlayingTvSeries();
}