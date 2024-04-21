import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Movies Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed Movies Watchlist';

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
      const MovieDetailState()
  ){
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(
          movieDetailState: RequestState.Loading
      ));

      final movieId = event.movieId;
      final result = await _getMovieDetail
          .execute(movieId);
      final recommendationsResult = await _getMovieRecommendations
          .execute(movieId);

      result.fold(
              (failure) {
                emit(state.copyWith(
                    movieDetailState: RequestState.Error,
                    movieDetailMsg: failure.message
                ));
              }, 
              (success) {
                emit(state.copyWith(
                    movieDetailState: RequestState.Loaded,
                    movieDetail: success,
                    movieRecommendationState: RequestState.Loading,
                ));

                recommendationsResult.fold(
                        (recommendationFailure) {
                          emit(state.copyWith(
                              movieRecommendationState: RequestState.Error,
                              movieRecommendationMsg: recommendationFailure.message,
                          ));
                        },
                        (recommendationSuccess) {
                          if (recommendationSuccess.isNotEmpty){
                            emit(state.copyWith(
                              movieRecommendationState: RequestState.Loaded,
                              movieRecommendations: recommendationSuccess,
                            ));
                          } else {
                            emit(state.copyWith(
                                movieRecommendationState: RequestState.Empty,
                                movieRecommendations: [],
                            ));
                          }
                        }
                );
              }
      );
    });

    on<AddWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await _saveWatchlist.execute(movieDetail);
      result.fold(
              (failure) {
                emit(
                  state.copyWith(
                    movieWatchlistMsg: failure.message
                  )
                );
              },
              (success) {
                emit(
                    state.copyWith(
                        movieWatchlistMsg: success
                    )
                );
              }
      );
      add(LoadWatchlistMovie(movieId: movieDetail.id));
    });

    on<RemoveWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await _removeWatchlist.execute(movieDetail);
      result.fold(
              (failure) {
                emit(
                    state.copyWith(
                        movieWatchlistMsg: failure.message
                    )
                );
          },
              (success) {
                emit(
                    state.copyWith(
                        movieWatchlistMsg: success
                    )
                );
          }
      );
      add(LoadWatchlistMovie(movieId: movieDetail.id));
    });

    on<LoadWatchlistMovie>((event, emit) async {
      final movieId = event.movieId;
      final result = await _getWatchListStatus.execute(movieId);
      emit(state.copyWith(movieWatchlistStatus: result));
    });
  }
}