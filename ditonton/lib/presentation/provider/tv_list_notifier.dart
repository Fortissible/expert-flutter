import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter/cupertino.dart';
import 'package:ditonton/common/state_enum.dart';

import '../../domain/entities/tv.dart';

class TvListNotifier extends ChangeNotifier{
  final GetNowPlayingTv getNowPlayingTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;
  List<Tv> _nowPlayingTv = [];
  List<Tv> get nowPlayingTv => _nowPlayingTv;
  String _nowPlayingErrorMsg = "";
  String get nowPlayingErrorMsg => _nowPlayingErrorMsg;

  RequestState _popularState = RequestState.Empty;
  RequestState get popularState => _popularState;
  List<Tv> _popularTv = [];
  List<Tv> get popularTv => _popularTv;
  String _popularErrorMsg = "";
  String get popularErrorMsg => _popularErrorMsg;

  RequestState _topRatedState = RequestState.Empty;
  RequestState get topRatedState => _topRatedState;
  List<Tv> _topRatedTv = [];
  List<Tv> get topRatedTv => _topRatedTv;
  String _topRatedErrorMsg = "";
  String get topRatedErrorMsg => _topRatedErrorMsg;

  TvListNotifier({
    required this.getTopRatedTv,
    required this.getPopularTv,
    required this.getNowPlayingTv
  });

  Future<void> fetchTopRatedTv() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();
    result.fold(
          (failure) {
        _topRatedState = RequestState.Error;
        _topRatedErrorMsg = failure.message;
        notifyListeners();
      },
          (tvData) {
        _topRatedState = RequestState.Loaded;
        _topRatedTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTv() async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTv.execute();
    result.fold(
          (failure) {
        _popularState = RequestState.Error;
        _popularErrorMsg = failure.message;
        notifyListeners();
      },
          (tvData) {
        _popularState = RequestState.Loaded;
        _popularTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchNowPlayingTv() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTv.execute();
    result.fold(
          (failure) {
        _nowPlayingState = RequestState.Error;
        _nowPlayingErrorMsg = failure.message;
        notifyListeners();
      },
          (tvData) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlayingTv = tvData;
        notifyListeners();
      },
    );
  }
}