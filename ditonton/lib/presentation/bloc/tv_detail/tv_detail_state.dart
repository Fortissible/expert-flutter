part of 'tv_detail_bloc.dart';

class TvDetailState extends Equatable {
  final RequestState tvDetailState;
  final String tvDetailMsg;
  final TvDetail? tvDetail;

  final RequestState tvRecommendationState;
  final String tvRecommendationMsg;
  final List<Tv> tvRecommendations;

  final String tvWatchlistMsg;
  final bool tvWatchlistStatus;

  final Seasons? tvSeasons;

  TvDetailState({
    this.tvDetailState = RequestState.Empty,
    this.tvDetailMsg = "",
    this.tvDetail,
    this.tvRecommendationState = RequestState.Empty,
    this.tvRecommendationMsg = "",
    required this.tvRecommendations,
    this.tvWatchlistMsg = "",
    this.tvWatchlistStatus = false,
    required this.tvSeasons
  });

  TvDetailState copyWith({
     RequestState? tvDetailState,
     String? tvDetailMsg,
     TvDetail? tvDetail,
     RequestState? tvRecommendationState,
     String? tvRecommendationMsg,
     List<Tv>? tvRecommendations,
     String? tvWatchlistMsg,
     bool? tvWatchlistStatus,
     Seasons? tvSeasons
  }) {
    return TvDetailState(
        tvDetailState: tvDetailState ?? this.tvDetailState,
        tvDetailMsg: tvDetailMsg ?? this.tvDetailMsg,
        tvDetail: tvDetail ?? this.tvDetail,
        tvRecommendationState: tvRecommendationState ?? this.tvRecommendationState,
        tvRecommendationMsg: tvRecommendationMsg ?? this.tvRecommendationMsg,
        tvRecommendations: tvRecommendations ?? this.tvRecommendations,
        tvWatchlistMsg: tvWatchlistMsg ?? this.tvWatchlistMsg,
        tvWatchlistStatus: tvWatchlistStatus ?? this.tvWatchlistStatus,
        tvSeasons: tvSeasons ?? this.tvSeasons
    );
  }

  @override
  List<Object?> get props => [
    tvDetailState,
    tvDetailMsg,
    tvDetail,
    tvRecommendationState,
    tvRecommendationMsg,
    tvRecommendations,
    tvWatchlistMsg,
    tvWatchlistStatus,
    tvSeasons
  ];
}