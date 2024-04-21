import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class SaveWatchlistTv {
  final TvRepository repository;

  SaveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.insertWatchlistTv(tv);
  }
}
