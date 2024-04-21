import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class SearchTvUsecase {
  final TvRepository repository;

  const SearchTvUsecase({
    required this.repository
  });

  Future<Either<Failure, List<Tv>>> execute(String query) async =>
      repository.searchTvSeries(query);
}