import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/get_watchlist_tv.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetWatchlistTv _getWatchlistTv;
  TvWatchlistBloc(
      this._getWatchlistTv
      ) : super(TvWatchlistState()) {
    on<FetchTvWatchlist>((event, emit) async {
      emit(state.copyWith(
          tvWatchlistState: RequestState.Loading
      ));
      final result = await _getWatchlistTv.execute();
      result.fold(
              (l) {
                emit(state.copyWith(
                  tvWatchlistState: RequestState.Error,
                  tvWatchlistMsg: l.message
                ));
              },
              (r) {
                emit(state.copyWith(
                  tvWatchlistState: r.isNotEmpty
                      ? RequestState.Loaded : RequestState.Empty,
                  tvWatchlist: r.isNotEmpty
                      ? r : []
                ));
              }
      );
    });
  }
}
