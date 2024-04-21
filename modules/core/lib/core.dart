library core;

export 'styles/colors.dart';
export 'styles/text.dart';

export 'common/constants.dart';
export 'common/exception.dart';
export 'common/failure.dart';
export 'common/state_enum.dart';
export 'common/utils.dart';

export 'data/datasources/db/database.dart';
export 'data/datasources/db/database_helper.dart';
export 'data/datasources/movie_local_data_source.dart';
export 'data/datasources/tv_local_data_source.dart';
export 'data/datasources/movie_remote_data_source.dart';
export 'data/datasources/tv_remote_data_source.dart';
export 'data/models/genre_model.dart';
export 'data/models/movie_detail_model.dart';
export 'data/models/movie_model.dart';
export 'data/models/movie_response.dart';
export 'data/models/movie_table.dart';
export 'data/models/seasons.dart';
export 'data/models/tv_detail_model.dart';
export 'data/models/tv_model.dart';
export 'data/models/tv_response.dart';
export 'data/models/tv_season_detail_model.dart';
export 'data/models/tv_table.dart';

export 'data/repositories/movie_repository_impl.dart';
export 'data/repositories/tv_repository_impl.dart';

export 'domain/entities/genre.dart';
export 'domain/entities/movie.dart';
export 'domain/entities/movie_detail.dart';
export 'domain/entities/tv.dart';
export 'domain/entities/tv_detail.dart';
export 'domain/entities/tv_season_detail.dart';
export 'domain/entities/tv_season_detail_args.dart';

export 'domain/repositories/movie_repository.dart';
export 'domain/repositories/tv_repository.dart';

export 'domain/usecases/get_movie_detail.dart';
export 'domain/usecases/get_movie_recommendations.dart';
export 'domain/usecases/get_now_playing_movies.dart';
export 'domain/usecases/get_popular_movies.dart';
export 'domain/usecases/get_top_rated_movies.dart';
export 'domain/usecases/get_watchlist_status.dart';
export 'domain/usecases/remove_watchlist.dart';
export 'domain/usecases/save_watchlist.dart';

export 'presentation/pages/home_movie_page.dart';
export 'presentation/pages/movie_detail_page.dart';
export 'presentation/pages/popular_movies_page.dart';
export 'presentation/pages/top_rated_movies_page.dart';

export 'presentation/widgets/movie_card_list.dart';
export 'presentation/widgets/tv_card_list.dart';

export 'presentation/bloc/movie_detail/movie_detail_bloc.dart';
export 'presentation/bloc/movie_list/movie_list_bloc.dart';
export 'presentation/bloc/movie_popular/movie_popular_bloc.dart';
export 'presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';




