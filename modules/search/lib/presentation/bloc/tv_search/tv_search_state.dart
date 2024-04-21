part of 'tv_search_bloc.dart';

class TvSearchState extends Equatable {
  final RequestState tvSearchState;
  final List<Tv>? tvSearch;
  final String tvSearchMsg;

  const TvSearchState({
    this.tvSearch,
    this.tvSearchMsg = "",
    this.tvSearchState = RequestState.Empty
  });

  TvSearchState copyWith({
    RequestState? tvSearchState,
    List<Tv>? tvSearch,
    String? tvSearchMsg,
  }) => TvSearchState(
      tvSearchState: tvSearchState ?? this.tvSearchState,
      tvSearch: tvSearch ?? this.tvSearch,
      tvSearchMsg: tvSearchMsg ?? this.tvSearchMsg
  );

  @override
  List<Object?> get props => [
    tvSearchState,
    tvSearch,
    tvSearchMsg
  ];
}