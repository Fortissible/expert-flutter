part of 'movie_watchlist_bloc.dart';

sealed class MovieWatchlistState extends Equatable {
  const MovieWatchlistState();
}

final class MovieWatchlistInitial extends MovieWatchlistState {
  @override
  List<Object> get props => [];
}
