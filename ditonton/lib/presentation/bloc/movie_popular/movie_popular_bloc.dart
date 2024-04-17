import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_popular_movies.dart';

part 'movie_popular_event.dart';
part 'movie_popular_state.dart';

class MoviePopularBloc extends Bloc<MoviePopularEvent, MoviePopularState> {
  final GetPopularMovies _getPopularMovies;
  MoviePopularBloc(
      this._getPopularMovies
  ) : super(MoviePopularState()) {

    on<FetchMoviesPopular>((event, emit) async {
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
  }
}
