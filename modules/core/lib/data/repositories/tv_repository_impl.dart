import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../core.dart';

class TvRepositoryImpl implements TvRepository{
  final TvRemoteDataSource tvRemoteDataSource;
  final TvLocalDataSource tvLocalDataSource;

  const TvRepositoryImpl({
    required this.tvLocalDataSource,
    required this.tvRemoteDataSource
  });

  @override
  Future<Either<Failure, TvDetail>> getDetailTvSeries(String tvId) async {
    try {
      final result = await tvRemoteDataSource.getDetailTvSeries(tvId);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TvSeasonDetail>> getSeasonDetailTvSeries(String tvId, String seasonId) async {
    try {
      final result = await tvRemoteDataSource.getSeasonDetailTvSeries(tvId,seasonId);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getNowPlayingTvSeries() async {
    try {
      final result = await tvRemoteDataSource.getNowPlayingTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTvSeries() async {
    try {
      final result = await tvRemoteDataSource.getPopularTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTvSeries() async {
    try {
      final result = await tvRemoteDataSource.getTopRatedTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTvSeries(String query) async {
    try {
      final result = await tvRemoteDataSource.searchTvSeries(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendation(String tvId) async {
    try {
      final result = await tvRemoteDataSource.getTvRecommendation(tvId);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTv() async {
    final result = await tvLocalDataSource.getWatchlistTv();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<Either<Failure, String>> insertWatchlistTv(TvDetail tv) async {
    try {
      final result =
        await tvLocalDataSource.insertTvWatchlist(TvTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlistTv(TvDetail tv) async {
    try {
      final result =
          await tvLocalDataSource.removeTvWatchlist(TvTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await tvLocalDataSource.getTvById(id);
    return result != null;
  }
}