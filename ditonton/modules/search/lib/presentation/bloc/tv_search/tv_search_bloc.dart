import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/domain/usecases/search_tv.dart';
part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvUsecase _searchTv;
  TvSearchBloc(
      this._searchTv
      ) : super(const TvSearchState()) {
    on<SearchTv>((event, emit) async {
      emit(
          state.copyWith(
              tvSearchState: RequestState.Loading
          )
      );
      final result = await _searchTv.execute(event.query);
      result.fold(
              (l) {
            emit(
                state.copyWith(
                    tvSearchState: RequestState.Error,
                    tvSearchMsg: l.message
                )
            );
          },
              (r) {
            if (r.isNotEmpty){
              emit(
                  state.copyWith(
                      tvSearchState: RequestState.Loaded,
                      tvSearch: r
                  )
              );
            } else {
              emit(
                  state.copyWith(
                      tvSearchState: RequestState.Empty,
                      tvSearch: []
                  )
              );
            }
          }
      );
    });
  }
}
