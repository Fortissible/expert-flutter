part of 'movie_top_rated_bloc.dart';

class MovieTopRatedState extends Equatable {
  final RequestState movieTopRatedState;
  final String movieTopRatedMsg;
  final List<Movie>? movieTopRated;

  MovieTopRatedState({
    this.movieTopRatedState = RequestState.Empty,
    this.movieTopRatedMsg = "",
    this.movieTopRated,
  });

  MovieTopRatedState copyWith({
    RequestState? movieTopRatedState,
    String? movieTopRatedMsg,
    List<Movie>? movieTopRated,
  }) => MovieTopRatedState(
    movieTopRatedState: movieTopRatedState ?? this.movieTopRatedState,
    movieTopRatedMsg: movieTopRatedMsg ?? this.movieTopRatedMsg,
    movieTopRated: movieTopRated ?? this.movieTopRated,
  );

  @override
  List<Object?> get props => [
    movieTopRatedState,
    movieTopRatedMsg,
    movieTopRated,
  ];
}
