part of 'movie_detail_bloc.dart';

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
}

class FetchMovieRecommendation extends MovieDetailEvent {
  final int movieId;
  const FetchMovieRecommendation({
    required this.movieId
  });
}

class AddWatchlistMovie extends MovieDetailEvent {
  final MovieDetail movieDetail;

  const AddWatchlistMovie({
    required this.movieDetail
  });
}

class RemoveWatchlistMovie extends MovieDetailEvent {
  final MovieDetail movieDetail;

  const RemoveWatchlistMovie({
    required this.movieDetail
  });
}

class LoadWatchlistMovie extends MovieDetailEvent {
  final int movieId;

  const LoadWatchlistMovie({
    required this.movieId
  });
}