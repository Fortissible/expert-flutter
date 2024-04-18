import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/tv_season_detail.dart';
import '../../../domain/usecases/get_tv_season_detail.dart';

part 'tv_season_event.dart';
part 'tv_season_state.dart';

class TvSeasonBloc extends Bloc<TvSeasonEvent, TvSeasonState> {
  final GetTvSeasonDetail _getTvSeasonDetail;

  TvSeasonBloc(
      this._getTvSeasonDetail
      ) : super(TvSeasonState()) {
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
