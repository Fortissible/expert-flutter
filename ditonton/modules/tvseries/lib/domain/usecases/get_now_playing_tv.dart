import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class GetNowPlayingTv {
  final TvRepository repository;

  const GetNowPlayingTv({
    required this.repository
  });

  Future<Either<Failure, List<Tv>>> execute()
    => repository.getNowPlayingTvSeries();
}