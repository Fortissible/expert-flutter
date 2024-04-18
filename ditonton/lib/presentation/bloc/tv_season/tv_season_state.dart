part of 'tv_season_bloc.dart';
final class TvSeasonState extends Equatable {
  final RequestState tvSeasonState;
  final TvSeasonDetail? tvSeason;
  final String tvSeasonMsg;

  const TvSeasonState({
    this.tvSeason,
    this.tvSeasonMsg = "",
    this.tvSeasonState = RequestState.Empty
  });

  TvSeasonState copyWith({
    RequestState? tvSeasonState,
    TvSeasonDetail? tvSeason,
    String? tvSeasonMsg,
  }) => TvSeasonState(
      tvSeasonState: tvSeasonState ?? this.tvSeasonState,
      tvSeason : tvSeason ?? this.tvSeason,
      tvSeasonMsg : tvSeasonMsg ?? this.tvSeasonMsg
  );

  @override
  List<Object?> get props => [tvSeasonState, tvSeason, tvSeasonMsg];
}
