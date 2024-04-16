import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int movieId;
  const FetchMovieDetail({
    required this.movieId
  });

  @override
  List<Object> get props => [];
}

class FetchMovieRecommendation extends MovieDetailEvent {
  final int movieId;
  const FetchMovieRecommendation({
    required this.movieId
  });

  @override
  List<Object> get props => [];
}