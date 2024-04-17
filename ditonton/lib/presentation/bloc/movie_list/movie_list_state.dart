part of 'movie_list_bloc.dart';
class MovieListState extends Equatable {
  final RequestState movieOnAirState;
  final String movieOnAirMsg;
  final List<Movie>? movieOnAir;

  final RequestState moviePopularState;
  final String moviePopularMsg;
  final List<Movie>? moviePopular;

  final RequestState movieTopRatedState;
  final String movieTopRatedMsg;
  final List<Movie>? movieTopRated;

  MovieListState({
    this.movieOnAirState = RequestState.Empty,
    this.movieOnAirMsg = "",
    this.movieOnAir,
    this.moviePopularState = RequestState.Empty,
    this.moviePopularMsg = "",
    this.moviePopular,
    this.movieTopRatedState = RequestState.Empty,
    this.movieTopRatedMsg = "",
    this.movieTopRated,
  });

  MovieListState copyWith({
    RequestState? movieOnAirState,
    String? movieOnAirMsg,
    List<Movie>? movieOnAir,
    RequestState? moviePopularState,
    String? moviePopularMsg,
    List<Movie>? moviePopular,
    RequestState? movieTopRatedState,
    String? movieTopRatedMsg,
    List<Movie>? movieTopRated,
  }) => MovieListState(
    movieOnAirState: movieOnAirState ?? this.movieOnAirState,
    movieOnAirMsg: movieOnAirMsg ?? this.movieOnAirMsg,
    movieOnAir: movieOnAir ?? this.movieOnAir,
    moviePopularState: moviePopularState ?? this.moviePopularState,
    moviePopularMsg: moviePopularMsg ?? this.moviePopularMsg,
    moviePopular: moviePopular ?? this.moviePopular,
    movieTopRatedState: movieTopRatedState ?? this.movieTopRatedState,
    movieTopRatedMsg: movieTopRatedMsg ?? this.movieTopRatedMsg,
    movieTopRated: movieTopRated ?? this.movieTopRated,
  );

  @override
  List<Object?> get props => [
    movieOnAirState,
    movieOnAirMsg,
    movieOnAir,
    moviePopularState,
    moviePopularMsg,
    moviePopular,
    movieTopRatedState,
    movieTopRatedMsg,
    movieTopRated,
  ];
}