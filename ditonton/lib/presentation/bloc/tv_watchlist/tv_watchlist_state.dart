part of 'tv_watchlist_bloc.dart';

sealed class TvWatchlistState extends Equatable {
  const TvWatchlistState();
}

final class TvWatchlistInitial extends TvWatchlistState {
  @override
  List<Object> get props => [];
}
