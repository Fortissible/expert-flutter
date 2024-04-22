import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get_it/get_it.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tv.dart';
import 'package:search/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:search/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:tvseries/tvseries.dart';
import 'package:watchlist/watchlist.dart';

final locator = GetIt.instance;

void init(ByteData sslCert) {
  // BLoC
  locator.registerFactory(
        () => MovieDetailBloc(
          locator(),
          locator(),
          locator(),
          locator(),
          locator()
    ),
  );
  locator.registerFactory(
        () => TvDetailBloc(
        locator(),
        locator(),
        locator(),
        locator(),
        locator()
    ),
  );
  locator.registerFactory(
    () => MovieListBloc(
        locator(),
        locator(),
        locator()
    )
  );
  locator.registerFactory(
          () => TvListBloc(
          locator(),
          locator(),
          locator()
      )
  );
  locator.registerFactory(
        () => MoviePopularBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => MovieTopRatedBloc(
          locator()
        ),
  );
  locator.registerFactory(
        () => MovieSearchBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TvSearchBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => MovieWatchlistBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TvWatchlistBloc(
      locator(),
    ),
  );
  locator.registerFactory(
          () => TvSeasonBloc(
          locator()
      )
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(
          () => GetTopRatedTv(repository: locator())
  );
  locator.registerLazySingleton(
          () => GetPopularTv(repository: locator())
  );
  locator.registerLazySingleton(
          () => GetNowPlayingTv(repository: locator())
  );
  locator.registerLazySingleton(
          () => GetTvDetail(repository: locator())
  );
  locator.registerLazySingleton(
          () => GetTvSeasonDetail(repository: locator())
  );
  locator.registerLazySingleton(
          () => SearchTvUsecase(repository: locator())
  );
  locator.registerLazySingleton(
          () => GetTvRecommendation(repository: locator())
  );
  locator.registerLazySingleton(
          () => GetWatchlistTv(locator())
  );
  locator.registerLazySingleton(
          () => GetWatchListTvStatus(locator())
  );
  locator.registerLazySingleton(
          () => RemoveWatchlistTv(locator())
  );
  locator.registerLazySingleton(
          () => SaveWatchlistTv(locator())
  );

  // repository
  locator.registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
          () => TvRepositoryImpl(
          tvLocalDataSource: locator(),
          tvRemoteDataSource: locator()
      )
  );

  // data sources
  locator.registerLazySingleton<TvRemoteDataSource>(
          () => TvRemoteDataSourceImpl(dio: locator())
  );
  locator.registerLazySingleton<TvLocalDataSource>(
          () => TvLocalDataSourceImpl(databaseHelper: locator())
  );
  locator.registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(dio: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
          () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper(
    database: locator<DatabaseInstance>().database
  ));

  // db instance
  locator.registerLazySingleton<DatabaseInstance>(() => DatabaseInstance());

  final Dio dio = Dio();
  final IOHttpClientAdapter interceptor = IOHttpClientAdapter(
      createHttpClient: (){
        final securityContext = SecurityContext(withTrustedRoots: false); //1
        securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
        final client = HttpClient(context: securityContext);
        client.badCertificateCallback = (cert, host, port) => false;
        return client;
      }
  );

  // external
  locator.registerLazySingleton((){
    dio.httpClientAdapter = interceptor;
    return dio;
  });
}