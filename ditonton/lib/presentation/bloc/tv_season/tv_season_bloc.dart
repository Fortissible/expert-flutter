import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_season_event.dart';
part 'tv_season_state.dart';

class TvSeasonBloc extends Bloc<TvSeasonEvent, TvSeasonState> {
  TvSeasonBloc() : super(TvSeasonInitial()) {
    on<TvSeasonEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
