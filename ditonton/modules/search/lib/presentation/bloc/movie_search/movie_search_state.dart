part of 'movie_search_bloc.dart';

class MovieSearchState extends Equatable {
  final RequestState movieSearchState;
  final List<Movie>? movieSearch;
  final String movieSearchMsg;

  const MovieSearchState({
    this.movieSearch,
    this.movieSearchMsg = "",
    this.movieSearchState = RequestState.Empty
  });

  MovieSearchState copyWith({
    RequestState? movieSearchState,
    List<Movie>? movieSearch,
    String? movieSearchMsg,
  }) => MovieSearchState(
      movieSearchState: movieSearchState ?? this.movieSearchState,
      movieSearch: movieSearch ?? this.movieSearch,
      movieSearchMsg: movieSearchMsg ?? this.movieSearchMsg
  );

  @override
  List<Object?> get props => [
    movieSearchState,
    movieSearch,
    movieSearchMsg
  ];
}