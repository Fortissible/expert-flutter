part of 'tv_season_bloc.dart';

abstract class TvSeasonEvent extends Equatable {
  const TvSeasonEvent();

  @override
  List<Object?> get props => [];
}

class FetchTvSeason extends TvSeasonEvent {
  final String tvId;
  final String seasonId;

  const FetchTvSeason({
    required this.tvId,
    required this.seasonId
  });
}
