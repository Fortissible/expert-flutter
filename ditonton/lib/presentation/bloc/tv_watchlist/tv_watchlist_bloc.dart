import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  TvWatchlistBloc() : super(TvWatchlistInitial()) {
    on<TvWatchlistEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
