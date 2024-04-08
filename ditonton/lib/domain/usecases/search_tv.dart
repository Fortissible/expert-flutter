import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class SearchTv {
  final TvRepository repository;

  const SearchTv({
    required this.repository
  });

  Future<Either<Failure, List<Tv>>> execute(String query) async =>
      repository.searchTvSeries(query);
}