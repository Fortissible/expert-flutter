import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  late Database database;
  late DatabaseHelper databaseHelper;
  const String _tblWatchlist = 'watchlist_movies';
  const String _tblWatchlistTv = 'watchlist_tv';

  tearDown(() async {
    await database.execute("DROP TABLE IF EXISTS $_tblWatchlist");
    await database.execute("DROP TABLE IF EXISTS $_tblWatchlistTv");
  });

  setUp(() async {
    sqfliteFfiInit();
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute("DROP TABLE IF EXISTS $_tblWatchlist");
    await database.execute("DROP TABLE IF EXISTS $_tblWatchlistTv");
    await database.execute(
    '''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    '''
    );
    await database.execute(
        '''
      CREATE TABLE  $_tblWatchlistTv (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    '''
    );
    databaseHelper = DatabaseHelper(database: database);
  });

  _arrangeInsertTv() async {
    await databaseHelper.insertWatchlistTv(
        testTvTable
    );
  }

  _arrangeDeleteTv() async {
    await databaseHelper.removeWatchlistTv(
        testTvTable
    );
  }

  _arrangeInsertMovie() async {
    await databaseHelper.insertWatchlist(
        testMovieTable
    );
  }

  _arrangeDeleteMovie() async {
    await databaseHelper.removeWatchlist(
        testMovieTable
    );
  }

  group('Database Test', () {
    test('sqflite version', () async {
      expect(await database.getVersion(), 0);
    });

    test('add Tv watchlist to database', () async {
      await databaseHelper.insertWatchlistTv(
        testTvTable
      );
      var resultTv = await databaseHelper.getWatchlistTv();
      expect(resultTv.length, 1);

      _arrangeDeleteTv();
    });

    test('remove Tv watchlist from database', () async {
      _arrangeInsertTv();
      await databaseHelper.removeWatchlistTv(
          testTvTable
      );
      var resultTv = await databaseHelper.getWatchlistTv();
      expect(resultTv.length, 0);
    });

    test('get Tv watchlist by Tv Id from database', () async {
      _arrangeInsertTv();
      var resultTv = await databaseHelper.getTvById(
          testTvTable.id
      );
      expect(resultTv!["id"], testTvTable.id);
      _arrangeDeleteMovie();
    });

    test('add Movie watchlist to database', () async {
      await databaseHelper.insertWatchlist(
          testMovieTable
      );
      var resultMovie = await databaseHelper.getWatchlistMovies();
      expect(resultMovie.length, 1);

      _arrangeDeleteMovie();
    });

    test('remove Movie watchlist from database', () async {
      _arrangeInsertMovie();
      await databaseHelper.removeWatchlist(
          testMovieTable
      );
      var resultMovie = await databaseHelper.getWatchlistTv();
      expect(resultMovie.length, 0);
    });

    test('get Movie watchlist by Movie Id from database', () async {
      _arrangeInsertMovie();
      var resultMovie = await databaseHelper.getMovieById(
          testMovieTable.id
      );
      expect(resultMovie!["id"], 1);
      _arrangeDeleteMovie();
    });
  });
}