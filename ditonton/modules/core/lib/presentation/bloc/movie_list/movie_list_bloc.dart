import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';
import '../../../domain/usecases/get_popular_movies.dart';
import '../../../domain/usecases/get_top_rated_movies.dart';
part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent,MovieListState>{
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetPopularMovies _getPopularMovies;
  final GetTopRatedMovies _getTopRatedMovies;

  MovieListBloc(
      this._getNowPlayingMovies,
      this._getPopularMovies,
      this._getTopRatedMovies
  ):super(
    const MovieListState() // INIT
  ){
    on<FetchOnAirMovie>((event, emit) async {
      emit(state.copyWith(
        movieOnAirState: RequestState.Loading
      ));
      final result = await _getNowPlayingMovies.execute();
      result.fold(
              (l) {
                emit(state.copyWith(
                    movieOnAirState: RequestState.Error,
                    movieOnAirMsg: l.message
                ));
              },
              (r) {
                if(r.isNotEmpty){
                  emit(state.copyWith(
                      movieOnAirState: RequestState.Loaded,
                      movieOnAir: r
                  ));
                } else {
                  emit(state.copyWith(
                      movieOnAirState: RequestState.Empty,
                      movieOnAir: []
                  ));
                }
              }
      );
    });

    on<FetchPopularMovie>((event, emit) async {
      emit(state.copyWith(
          moviePopularState: RequestState.Loading
      ));
      final result = await _getPopularMovies.execute();
      result.fold(
              (l) {
            emit(state.copyWith(
                moviePopularState: RequestState.Error,
                moviePopularMsg: l.message
            ));
          },
              (r) {
                if (r.isNotEmpty){
                  emit(state.copyWith(
                      moviePopularState: RequestState.Loaded,
                      moviePopular: r
                  ));
                } else {
                  emit(state.copyWith(
                      moviePopularState: RequestState.Empty,
                      moviePopular: []
                  ));
                }
          }
      );
    });

    on<FetchTopRatedMovie>((event, emit) async {
      emit(state.copyWith(
          movieTopRatedState: RequestState.Loading
      ));
      final result = await _getTopRatedMovies.execute();
      result.fold(
              (l) {
            emit(state.copyWith(
                movieTopRatedState: RequestState.Error,
                movieTopRatedMsg: l.message
            ));
          },
              (r) {
            if (r.isNotEmpty){
              emit(state.copyWith(
                  movieTopRatedState: RequestState.Loaded,
                  movieTopRated: r
              ));
            } else {
              emit(state.copyWith(
                  movieTopRatedState: RequestState.Empty,
                  movieTopRated: []
              ));
            }
          }
      );
    });
  }

}