part of 'tv_season_bloc.dart';

sealed class TvSeasonState extends Equatable {
  const TvSeasonState();
}

final class TvSeasonInitial extends TvSeasonState {
  @override
  List<Object> get props => [];
}
