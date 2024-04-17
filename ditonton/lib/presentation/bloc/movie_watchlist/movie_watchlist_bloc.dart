import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  MovieWatchlistBloc() : super(MovieWatchlistInitial()) {
    on<MovieWatchlistEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
