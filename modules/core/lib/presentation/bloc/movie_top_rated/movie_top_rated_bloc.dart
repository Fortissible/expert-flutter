import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
