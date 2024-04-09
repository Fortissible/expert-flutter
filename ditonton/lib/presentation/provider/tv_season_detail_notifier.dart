import 'package:ditonton/domain/entities/tv_season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_season_detail.dart';
import 'package:flutter/material.dart';

import '../../common/state_enum.dart';

class TvSeasonDetailNotifier extends ChangeNotifier {
  final GetTvSeasonDetail getTvSeasonDetail;

  RequestState _tvSeasonDetailState = RequestState.Empty;
  RequestState get tvSeasonDetailState => _tvSeasonDetailState;
  TvSeasonDetail? _tvSeasonDetail;
  TvSeasonDetail? get tvSeasonDetail => _tvSeasonDetail;
  String _tvSeasonDetailErrorMsg = "";
  String get tvSeasonDetailErrorMsg => _tvSeasonDetailErrorMsg;

  TvSeasonDetailNotifier({
    required this.getTvSeasonDetail,
  });

  Future<void> fetchTvSeasonDetail(String id, String seasonId) async {
    _tvSeasonDetailState = RequestState.Loading;
    notifyListeners();

    final result = await getTvSeasonDetail.execute(id, seasonId);
    result.fold(
            (failure) {
          _tvSeasonDetailState = RequestState.Error;
          _tvSeasonDetailErrorMsg = failure.message;
          notifyListeners();
        },
            (success) {
          _tvSeasonDetailState = RequestState.Loaded;
          _tvSeasonDetail = success;
          notifyListeners();
        }
    );
  }
}