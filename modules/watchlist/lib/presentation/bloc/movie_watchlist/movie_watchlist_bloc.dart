import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/watchlist.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies _getWatchlistMovies;

  MovieWatchlistBloc(
      this._getWatchlistMovies
      ) : super(const MovieWatchlistState()) {
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
