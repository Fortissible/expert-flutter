part of 'tv_list_bloc.dart';
class TvListState extends Equatable {
  final RequestState tvOnAirState;
  final String tvOnAirMsg;
  final List<Tv>? tvOnAir;

  final RequestState tvPopularState;
  final String tvPopularMsg;
  final List<Tv>? tvPopular;

  final RequestState tvTopRatedState;
  final String tvTopRatedMsg;
  final List<Tv>? tvTopRated;

  TvListState({
    this.tvOnAirState = RequestState.Empty,
    this.tvOnAirMsg = "",
    this.tvOnAir,
    this.tvPopularState = RequestState.Empty,
    this.tvPopularMsg = "",
    this.tvPopular,
    this.tvTopRatedState = RequestState.Empty,
    this.tvTopRatedMsg = "",
    this.tvTopRated,
  });

  TvListState copyWith({
    RequestState? tvOnAirState,
    String? tvOnAirMsg,
    List<Tv>? tvOnAir,
    RequestState? tvPopularState,
    String? tvPopularMsg,
    List<Tv>? tvPopular,
    RequestState? tvTopRatedState,
    String? tvTopRatedMsg,
    List<Tv>? tvTopRated,
  }) => TvListState(
    tvOnAirState: tvOnAirState ?? this.tvOnAirState,
    tvOnAirMsg: tvOnAirMsg ?? this.tvOnAirMsg,
    tvOnAir: tvOnAir ?? this.tvOnAir,
    tvPopularState: tvPopularState ?? this.tvPopularState,
    tvPopularMsg: tvPopularMsg ?? this.tvPopularMsg,
    tvPopular: tvPopular ?? this.tvPopular,
    tvTopRatedState: tvTopRatedState ?? this.tvTopRatedState,
    tvTopRatedMsg: tvTopRatedMsg ?? this.tvTopRatedMsg,
    tvTopRated: tvTopRated ?? this.tvTopRated,
  );

  @override
  List<Object?> get props => [
    tvOnAirState,
    tvOnAirMsg,
    tvOnAir,
    tvPopularState,
    tvPopularMsg,
    tvPopular,
    tvTopRatedState,
    tvTopRatedMsg,
    tvTopRated,
  ];
}