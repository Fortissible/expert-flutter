import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';

class MovieDetailState extends Equatable{
  final RequestState movieDetailState;
  final String movieDetailMsg;
  final MovieDetail? movieDetail;
  final RequestState movieRecommendationState;
  final String movieRecommendationMsg;
  final List<Movie> movieRecommendations;
  MovieDetailState({
    this.movieDetailState = RequestState.Empty,
    this.movieDetailMsg = "",
    this.movieDetail,
    this.movieRecommendationState  = RequestState.Empty,
    this.movieRecommendationMsg = "",
    required this.movieRecommendations
  });

  @override
  List<Object> get props => [
    movieDetailState,
    movieRecommendationState,
  ];
}