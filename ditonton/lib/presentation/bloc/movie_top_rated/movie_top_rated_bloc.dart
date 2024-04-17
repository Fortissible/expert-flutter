import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_popular_movies.dart';

part 'movie_top_rated_event.dart';
part 'movie_top_rated_state.dart';

class MovieTopRatedBloc extends Bloc<MovieTopRatedEvent, MovieTopRatedState> {
  final GetTopRatedMovies _getTopRatedMovies;
  MovieTopRatedBloc(
      this._getTopRatedMovies
      ) : super(MovieTopRatedState()) {

    on<FetchMoviesTopRated>((event, emit) async {
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
