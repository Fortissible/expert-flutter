import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/seasons.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/get_tv_detail.dart';
import '../../../domain/usecases/get_tv_recommendation.dart';
import '../../../domain/usecases/get_watchlist_tv_status.dart';
import '../../../domain/usecases/remove_watchlist_tv.dart';
import '../../../domain/usecases/save_watchlist_tv.dart';
part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState>{
  static const watchlistAddSuccessMessage = 'Added to TV Series Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from TV Series Watchlist';

  final GetTvDetail _getTvDetail;
  final GetTvRecommendation _getTvRecommendation;
  final GetWatchListTvStatus _getWatchListStatus;
  final SaveWatchlistTv _saveWatchlist;
  final RemoveWatchlistTv _removeWatchlist;

  TvDetailBloc(
      this._getTvDetail,
      this._getTvRecommendation,
      this._getWatchListStatus,
      this._removeWatchlist,
      this._saveWatchlist
  ) : super(
      TvDetailState(
        tvRecommendations: [],
        tvSeasons: Seasons(
            expandedValue: ["Season 0 - 0 Episodes"],
            headerValue: "0 Seasons"
        )
      )
  ) {

    on<FetchTvDetail>((event, emit) async {
      emit(
          state.copyWith(
              tvDetailState: RequestState.Loading,
          )
      );

      final tvId = event.tvId;

      final detailResult = await _getTvDetail.execute(tvId.toString());
      final recommendationResult = await _getTvRecommendation.execute(tvId.toString());

      detailResult.fold(
              (failure) {
                emit(
                  state.copyWith(
                    tvDetailState: RequestState.Error,
                    tvDetailMsg:  failure.message
                  )
                );
              },
              (success) {
                List<String> expandedValue = [];
                for(var i = 0; i < success.seasons.length; i++){
                  expandedValue.add("• Season ${i+1} - ${success.seasons[i].episodeCount} Episode\n");
                }
                final season = Seasons(
                    expandedValue: expandedValue,
                    headerValue: "${success.seasons.length} Seasons"
                );

                emit(
                    state.copyWith(
                        tvDetailState: RequestState.Loaded,
                        tvDetail: success,
                        tvRecommendationState: RequestState.Loading,
                        tvSeasons: season
                    )
                );

                recommendationResult.fold(
                        (recommendationFailure) {
                          emit(
                              state.copyWith(
                                  tvRecommendationState: RequestState.Error,
                                  tvRecommendationMsg: recommendationFailure.message
                              )
                          );
                        },
                        (recommendationSuccess) {
                          emit(
                              state.copyWith(
                                  tvRecommendationState: RequestState.Loaded,
                                  tvRecommendations: recommendationSuccess
                              )
                          );
                        }
                );
              }
      );
    });

    on<AddTvWatchlist>((event, emit) async {
      final tvDetail = event.tv;

      final resultMsg = await _saveWatchlist.execute(tvDetail);

      resultMsg.fold(
              (failure) {
                emit(
                  state.copyWith(
                    tvWatchlistMsg: failure.message
                  )
                );
              },
              (success) {
                emit(
                    state.copyWith(
                        tvWatchlistMsg: success
                    )
                );
              }
      );

      add(LoadTvWatchlist(tvId: tvDetail.id));
    });

    on<RemoveTvWatchlist>((event, emit) async {
      final tvDetail = event.tv;

      final resultMsg = await _removeWatchlist.execute(tvDetail);

      resultMsg.fold(
              (failure) {
            emit(
                state.copyWith(
                    tvWatchlistMsg: failure.message
                )
            );
          },
              (success) {
            emit(
                state.copyWith(
                    tvWatchlistMsg: success
                )
            );
          }
      );

      add(LoadTvWatchlist(tvId: tvDetail.id));
    });

    on<LoadTvWatchlist>((event, emit) async {
      final tvId = event.tvId;
      final result = await _getWatchListStatus.execute(tvId);
      emit(state.copyWith(tvWatchlistStatus: result));
    });

    on<ExpandSeasonDetail>((event, emit) async {
      final isExpanded = event.isExpanded;
      emit(state.copyWith(tvSeasons: Seasons(
          expandedValue: state.tvSeasons!.expandedValue,
          headerValue: state.tvSeasons!.headerValue,
          isExpanded: isExpanded
      )));
    });
  }
}