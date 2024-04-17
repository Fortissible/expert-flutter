part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object?> get props => [];
}

class FetchOnAirMovie extends MovieListEvent {
  const FetchOnAirMovie();
}

class FetchPopularMovie extends MovieListEvent {
  const FetchPopularMovie();
}

class FetchTopRatedMovie extends MovieListEvent {
  const FetchTopRatedMovie();
}