part of 'tv_watchlist_bloc.dart';

class TvWatchlistState extends Equatable {
  final RequestState tvWatchlistState;
  final List<Tv>? tvWatchlist;
  final String tvWatchlistMsg;

  const TvWatchlistState({
    this.tvWatchlistMsg = "",
    this.tvWatchlist,
    this.tvWatchlistState = RequestState.Empty
  });

  TvWatchlistState copyWith({
    RequestState? tvWatchlistState,
    List<Tv>? tvWatchlist,
    String? tvWatchlistMsg,
  }) => TvWatchlistState(
      tvWatchlistState: tvWatchlistState ?? this.tvWatchlistState,
      tvWatchlist: tvWatchlist ?? this.tvWatchlist,
      tvWatchlistMsg: tvWatchlistMsg ?? this.tvWatchlistMsg
  );

  @override
  List<Object?> get props => [
    tvWatchlistState,
    tvWatchlist,
    tvWatchlistMsg
  ];
}
