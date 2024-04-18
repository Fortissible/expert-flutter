part of 'movie_watchlist_bloc.dart';

final class MovieWatchlistState extends Equatable {
  final RequestState movieWatchlistState;
  final List<Movie>? movieWatchlist;
  final String movieWatchlistMsg;

  const MovieWatchlistState({
    this.movieWatchlistMsg = "",
    this.movieWatchlist,
    this.movieWatchlistState = RequestState.Empty
  });

  MovieWatchlistState copyWith ({
    RequestState? movieWatchlistState,
    List<Movie>? movieWatchlist,
    String? movieWatchlistMsg,
  }) => MovieWatchlistState(
    movieWatchlistState : movieWatchlistState ?? this.movieWatchlistState,
    movieWatchlist: movieWatchlist ?? this.movieWatchlist,
    movieWatchlistMsg: movieWatchlistMsg ?? this.movieWatchlistMsg,
  );

  @override
  List<Object?> get props => [
    movieWatchlistState,
    movieWatchlist,
    movieWatchlistMsg
  ];
}
