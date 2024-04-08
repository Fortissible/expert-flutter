import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/movie_table.dart';


//TODO CREATE WATCHLIST FOR TV SERIES
abstract class TvLocalDataSource {
  // Future<String> insertTvWatchlist(MovieTable movie);
  // Future<String> removeTvWatchlist(MovieTable movie);
  // Future<MovieTable?> getTvById(int id);
  // Future<List<MovieTable>> getWatchlistTv();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  // @override
  // Future<String> insertTvWatchlist(MovieTable movie) async {
  //   try {
  //     await databaseHelper.insertTvWatchlist(movie);
  //     return 'Added to Watchlist';
  //   } catch (e) {
  //     throw DatabaseException(e.toString());
  //   }
  // }
  //
  // @override
  // Future<String> removeTvWatchlist(MovieTable movie) async {
  //   try {
  //     await databaseHelper.removeTvWatchlist(movie);
  //     return 'Removed from Watchlist';
  //   } catch (e) {
  //     throw DatabaseException(e.toString());
  //   }
  // }
  //
  // @override
  // Future<MovieTable?> getTvById(int id) async {
  //   final result = await databaseHelper.getTvById(id);
  //   if (result != null) {
  //     return MovieTable.fromMap(result);
  //   } else {
  //     return null;
  //   }
  // }
  //
  // @override
  // Future<List<MovieTable>> getWatchlistTv() async {
  //   final result = await databaseHelper.getWatchlistTv();
  //   return result.map((data) => MovieTable.fromMap(data)).toList();
  // }
}