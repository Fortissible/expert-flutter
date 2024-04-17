import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/search_tv.dart' as usecase;

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final usecase.SearchTv _searchTv;
  TvSearchBloc(
      this._searchTv
      ) : super(TvSearchState()) {
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
