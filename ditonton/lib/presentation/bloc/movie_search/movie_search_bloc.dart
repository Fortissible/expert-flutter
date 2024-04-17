import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/movie.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies _searchMovie;
  MovieSearchBloc(
      this._searchMovie
      ) : super(MovieSearchState()) {
    on<SearchMovie>((event, emit) async {
      emit(
        state.copyWith(
          movieSearchState: RequestState.Loading
        )
      );
      final result = await _searchMovie.execute(event.query);
      result.fold(
              (l) {
                emit(
                    state.copyWith(
                      movieSearchState: RequestState.Error,
                      movieSearchMsg: l.message
                    )
                );
              },
              (r) {
                if (r.isNotEmpty){
                  emit(
                      state.copyWith(
                          movieSearchState: RequestState.Loaded,
                          movieSearch: r
                      )
                  );
                } else {
                  emit(
                      state.copyWith(
                          movieSearchState: RequestState.Empty,
                          movieSearch: []
                      )
                  );
                }
              }
      );
    });
  }
}
