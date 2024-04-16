part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable{
  final RequestState movieDetailState;
  final String movieDetailMsg;
  final MovieDetail? movieDetail;

  final RequestState movieRecommendationState;
  final String movieRecommendationMsg;
  final List<Movie> movieRecommendations;

  final String movieWatchlistMsg;
  final bool movieWatchlistStatus;

  MovieDetailState({
    this.movieDetailState = RequestState.Empty,
    this.movieDetailMsg = "",
    this.movieDetail,
    this.movieRecommendationState  = RequestState.Empty,
    this.movieRecommendationMsg = "",
    required this.movieRecommendations,
    this.movieWatchlistMsg = "",
    this.movieWatchlistStatus = false
  });

  MovieDetailState copyWith({
    RequestState? movieDetailState,
    String? movieDetailMsg,
    MovieDetail? movieDetail,
    RequestState? movieRecommendationState,
    String? movieRecommendationMsg,
    List<Movie>? movieRecommendations,
    String? movieWatchlistMsg,
    bool? movieWatchlistStatus,
  }) {
    return MovieDetailState(
      movieDetailState: movieDetailState ?? this.movieDetailState,
      movieDetailMsg: movieDetailMsg ?? this.movieDetailMsg,
      movieDetail: movieDetail ?? this.movieDetail,
      movieRecommendationState: movieRecommendationState ?? this.movieRecommendationState,
      movieRecommendationMsg: movieRecommendationMsg ?? this.movieRecommendationMsg,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieWatchlistMsg: movieWatchlistMsg ?? this.movieWatchlistMsg,
      movieWatchlistStatus: movieWatchlistStatus ?? this.movieWatchlistStatus,
    );
  }

  @override
  List<Object?> get props => [
    movieDetailState,
    movieDetailMsg,
    movieDetail,
    movieRecommendationState,
    movieRecommendationMsg,
    movieRecommendations,
    movieWatchlistMsg,
    movieWatchlistStatus,
  ];
}