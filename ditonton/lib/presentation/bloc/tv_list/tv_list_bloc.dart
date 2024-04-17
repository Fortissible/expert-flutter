import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/get_now_playing_tv.dart';
import '../../../domain/usecases/get_popular_tv.dart';
import '../../../domain/usecases/get_top_rated_tv.dart';
part 'tv_list_event.dart';
part 'tv_list_state.dart';
class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetNowPlayingTv _getNowPlayingTv;
  final GetPopularTv _getPopularTv;
  final GetTopRatedTv _getTopRatedTv;
  TvListBloc(
      this._getNowPlayingTv,
      this._getPopularTv,
      this._getTopRatedTv
  ): super(
    TvListState() // INIT
  ){
    on<FetchOnAirTv>((event, emit) async {
      emit(state.copyWith(
          tvOnAirState: RequestState.Loading
      ));
      final result = await _getNowPlayingTv.execute();
      result.fold(
              (l) {
            emit(state.copyWith(
                tvOnAirState: RequestState.Error,
                tvOnAirMsg: l.message
            ));
          },
              (r) {
            emit(state.copyWith(
                tvOnAirState: RequestState.Loaded,
                tvOnAir: r
            ));
          }
      );
    });

    on<FetchPopularTv>((event, emit) async {
      emit(state.copyWith(
          tvPopularState: RequestState.Loading
      ));
      final result = await _getPopularTv.execute();
      result.fold(
              (l) {
            emit(state.copyWith(
                tvPopularState: RequestState.Error,
                tvPopularMsg: l.message
            ));
          },
              (r) {
            emit(state.copyWith(
                tvPopularState: RequestState.Loaded,
                tvPopular: r
            ));
          }
      );
    });

    on<FetchTopRatedTv>((event, emit) async {
      emit(state.copyWith(
          tvTopRatedState: RequestState.Loading
      ));
      final result = await _getTopRatedTv.execute();
      result.fold(
              (l) {
            emit(state.copyWith(
                tvTopRatedState: RequestState.Error,
                tvTopRatedMsg: l.message
            ));
          },
              (r) {
            emit(state.copyWith(
                tvTopRatedState: RequestState.Loaded,
                tvTopRated: r
            ));
          }
      );
    });
  }
}