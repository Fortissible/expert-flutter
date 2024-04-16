import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';
import '../../../domain/usecases/get_watchlist_status.dart';
import '../../../domain/usecases/remove_watchlist.dart';
import '../../../domain/usecases/save_watchlist.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  MovieDetailBloc(
      this._getMovieDetail,
      this._getMovieRecommendations,
      this._getWatchListStatus,
      this._removeWatchlist,
      this._saveWatchlist
  ):super(
      MovieDetailState(movieRecommendations: [])
  ){
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailState(
          movieRecommendations: [],
          movieDetailState: RequestState.Loading
      ));

      final movieId = event.movieId;
      final result = await _getMovieDetail
          .execute(movieId);
      final recommendationsResult = await _getMovieRecommendations
          .execute(movieId);

      result.fold(
              (failure) {
                emit(MovieDetailState(
                    movieRecommendations: [],
                    movieDetailState: RequestState.Error,
                    movieDetailMsg: failure.message
                ));
              }, 
              (success) {
                emit(MovieDetailState(
                    movieRecommendationState: RequestState.Loading,
                    movieRecommendations: [],
                    movieDetailState: RequestState.Loaded,
                    movieDetail: success
                ));

                recommendationsResult.fold(
                        (recommendationFailure) {
                          emit(MovieDetailState(
                              movieRecommendationState: RequestState.Error,
                              movieRecommendationMsg: recommendationFailure.message,
                              movieRecommendations: [],
                              movieDetailState: RequestState.Loaded,
                              movieDetail: success
                          ));
                        },
                        (recommendationSuccess) {
                          if (recommendationSuccess.isNotEmpty){
                            emit(MovieDetailState(
                              movieRecommendationState: RequestState.Loaded,
                              movieRecommendations: recommendationSuccess,
                              movieDetailState: RequestState.Loaded,
                              movieDetail: success,
                            ));
                          } else {
                            emit(MovieDetailState(
                                movieRecommendationState: RequestState.Empty,
                                movieRecommendations: [],
                                movieDetailState: RequestState.Loaded,
                                movieDetail: success
                            ));
                          }
                        }
                );
              }
      );
    });
  }
}