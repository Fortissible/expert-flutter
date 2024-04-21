import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';
part 'tv_season_event.dart';
part 'tv_season_state.dart';

class TvSeasonBloc extends Bloc<TvSeasonEvent, TvSeasonState> {
  final GetTvSeasonDetail _getTvSeasonDetail;

  TvSeasonBloc(
      this._getTvSeasonDetail
      ) : super(const TvSeasonState()) {
    on<FetchTvSeason>((event, emit) async {
      emit(
        state.copyWith(
          tvSeasonState: RequestState.Loading
        )
      );

      final result = await _getTvSeasonDetail.execute(
          event.tvId, event.seasonId
      );

      result.fold(
              (l) {
                emit(
                    state.copyWith(
                        tvSeasonState: RequestState.Error,
                        tvSeasonMsg: l.message
                    )
                );
              },
              (r) {
                emit(
                  state.copyWith(
                    tvSeasonState: RequestState.Loaded,
                    tvSeason: r
                  )
                );
              }
      );
    });
  }
}
