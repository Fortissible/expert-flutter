import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:flutter/cupertino.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/tv.dart';

class TvSearchNotifier extends ChangeNotifier {
  final SearchTv searchTv;

  RequestState _searchState = RequestState.Empty;
  RequestState get searchState => _searchState;
  List<Tv> _searchTvList = [];
  List<Tv> get searchTvList => _searchTvList;
  String _searchTvErrorMsg = "";
  String get searchTvErrorMsg => _searchTvErrorMsg;

  TvSearchNotifier({
    required this.searchTv
  });

  Future<void> fetchSearchTv(String query) async {
    _searchState = RequestState.Loading;
    notifyListeners();

    final result = await searchTv.execute(query);
    result.fold(
            (failure) {
              _searchState = RequestState.Error;
              _searchTvErrorMsg = failure.message;
              notifyListeners();
            },
            (success) {
              _searchState = RequestState.Loaded;
              _searchTvList = success;
              notifyListeners();
            }
    );
  }
}