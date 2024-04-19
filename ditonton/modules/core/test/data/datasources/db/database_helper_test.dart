import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  late DatabaseHelper databaseHelper;
  late Database? database;
  const String tblWatchlist = 'watchlist_movies';
  const String tblWatchlistTv = 'watchlist_tv';

  tearDown(() async {
    await database!.execute("DROP TABLE IF EXISTS $tblWatchlist");
    await database!.execute("DROP TABLE IF EXISTS $tblWatchlistTv");
  });

  setUp(() async {
    sqfliteFfiInit();
    final futureDb = databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    databaseHelper = DatabaseHelper(database: futureDb);
    database = await databaseHelper.database;
    await database!.execute("DROP TABLE IF EXISTS $tblWatchlist");
    await database!.execute("DROP TABLE IF EXISTS $tblWatchlistTv");
    await database!.execute(
        '''
      CREATE TABLE  $tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    '''
    );
    await database!.execute(
        '''
      CREATE TABLE  $tblWatchlistTv (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    '''
    );
  });

  arrangeInsertTv() async {
    await databaseHelper.insertWatchlistTv(
        testTvTable
    );
  }

  arrangeDeleteTv() async {
    await databaseHelper.removeWatchlistTv(
        testTvTable
    );
  }

  arrangeInsertMovie() async {
    await databaseHelper.insertWatchlist(
        testMovieTable
    );
  }

  arrangeDeleteMovie() async {
    await databaseHelper.removeWatchlist(
        testMovieTable
    );
  }

  group('Database Test', () {
    test('sqflite version', () async {
      expect(await database!.getVersion(), 0);
    });

    test('add Tv watchlist to database', () async {
      await databaseHelper.insertWatchlistTv(
        testTvTable
      );
      var resultTv = await databaseHelper.getWatchlistTv();
      expect(resultTv.length, 1);

      arrangeDeleteTv();
    });

    test('remove Tv watchlist from database', () async {
      arrangeInsertTv();
      await databaseHelper.removeWatchlistTv(
          testTvTable
      );
      var resultTv = await databaseHelper.getWatchlistTv();
      expect(resultTv.length, 0);
    });

    test('get Tv watchlist by Tv Id from database', () async {
      arrangeInsertTv();
      var resultTv = await databaseHelper.getTvById(
          testTvTable.id
      );
      expect(resultTv!["id"], testTvTable.id);
      arrangeDeleteMovie();
    });

    test('add Movie watchlist to database', () async {
      await databaseHelper.insertWatchlist(
          testMovieTable
      );
      var resultMovie = await databaseHelper.getWatchlistMovies();
      expect(resultMovie.length, 1);

      arrangeDeleteMovie();
    });

    test('remove Movie watchlist from database', () async {
      arrangeInsertMovie();
      await databaseHelper.removeWatchlist(
          testMovieTable
      );
      var resultMovie = await databaseHelper.getWatchlistTv();
      expect(resultMovie.length, 0);
    });

    test('get Movie watchlist by Movie Id from database', () async {
      arrangeInsertMovie();
      var resultMovie = await databaseHelper.getMovieById(
          testMovieTable.id
      );
      expect(resultMovie!["id"], 1);
      arrangeDeleteMovie();
    });
  });
}