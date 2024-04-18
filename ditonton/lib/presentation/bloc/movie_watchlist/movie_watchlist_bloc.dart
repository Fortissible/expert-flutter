import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_watchlist_movies.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies _getWatchlistMovies;

  MovieWatchlistBloc(
      this._getWatchlistMovies
      ) : super(MovieWatchlistState()) {
    on<FetchMovieWatchlist>((event, emit) async {
      emit(
        state.copyWith(
          movieWatchlistState: RequestState.Loading
        )
      );
      final result = await _getWatchlistMovies.execute();
      result.fold(
              (l) {
                emit(
                    state.copyWith(
                        movieWatchlistState: RequestState.Error,
                        movieWatchlistMsg: l.message
                    )
                );
              },
              (r) {
                emit(
                    state.copyWith(
                        movieWatchlistState: r.isNotEmpty
                            ? RequestState.Loaded : RequestState.Empty,
                        movieWatchlist: r.isNotEmpty
                            ? r : []
                    )
                );
              }
      );
    });
  }
}
