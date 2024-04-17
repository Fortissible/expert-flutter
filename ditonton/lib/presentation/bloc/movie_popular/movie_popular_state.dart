part of 'movie_popular_bloc.dart';

class MoviePopularState extends Equatable {
  final RequestState moviePopularState;
  final String moviePopularMsg;
  final List<Movie>? moviePopular;

  MoviePopularState({
    this.moviePopularState = RequestState.Empty,
    this.moviePopularMsg = "",
    this.moviePopular,
  });

  MoviePopularState copyWith({
    RequestState? moviePopularState,
    String? moviePopularMsg,
    List<Movie>? moviePopular
  }) => MoviePopularState(
    moviePopularState: moviePopularState ?? this.moviePopularState,
    moviePopularMsg: moviePopularMsg ?? this.moviePopularMsg,
    moviePopular: moviePopular ?? this.moviePopular,
  );

  @override
  List<Object?> get props => [
    moviePopularState,
    moviePopularMsg,
    moviePopular,
  ];
}
