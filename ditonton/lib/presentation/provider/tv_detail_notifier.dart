import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:flutter/cupertino.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/tv_detail.dart';

class TvDetailNotifier extends ChangeNotifier {
  final GetTvDetail getTvDetail;

  RequestState _tvDetailState = RequestState.Empty;
  RequestState get tvDetailState => _tvDetailState;
  TvDetail? _tvDetail;
  TvDetail? get tvDetail => _tvDetail;
  String _tvDetailErrorMsg = "";
  String get tvDetailErrorMsg => _tvDetailErrorMsg;

  TvDetailNotifier({
    required this.getTvDetail
  });

  Future<void> fetchTvDetail(String id) async {
    _tvDetailState = RequestState.Loading;
    notifyListeners();

    final result = await getTvDetail.execute(id);
    result.fold(
            (failure) {
              _tvDetailState = RequestState.Error;
              _tvDetailErrorMsg = failure.message;
              notifyListeners();
            },
            (success) {
              _tvDetailState = RequestState.Loaded;
              _tvDetail = success;
              notifyListeners();
            }
    );
  }
}