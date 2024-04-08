import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendation.dart';
import 'package:flutter/cupertino.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';

class TvDetailNotifier extends ChangeNotifier {
  final GetTvDetail getTvDetail;
  final GetTvRecommendation getTvRecommendation;

  RequestState _tvDetailState = RequestState.Empty;
  RequestState get tvDetailState => _tvDetailState;
  TvDetail? _tvDetail;
  TvDetail? get tvDetail => _tvDetail;
  String _tvDetailErrorMsg = "";
  String get tvDetailErrorMsg => _tvDetailErrorMsg;

  RequestState _tvRecommendationState = RequestState.Empty;
  RequestState get tvRecommendationState => _tvRecommendationState;
  List<Tv> _tvRecommendations = [];
  List<Tv> get tvRecommendations => _tvRecommendations;
  String _tvRecommendationsErrorMsg = "";
  String get tvRecommendationsErrorMsg => _tvRecommendationsErrorMsg;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendation
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
    fetchTvRecommendations(id);
  }

  Future<void> fetchTvRecommendations(String id) async {
    _tvRecommendationState = RequestState.Loading;
    notifyListeners();
    print("TVs ID: $id");
    final result = await getTvRecommendation.execute(id);
    result.fold(
            (failure) {
              _tvRecommendationState = RequestState.Error;
              _tvRecommendationsErrorMsg = failure.message;
              notifyListeners();
        },
          (success) {
              print("TV RECOMMENDATIONS SUCCESS");
              print(success);
              _tvRecommendationState = RequestState.Loaded;
              _tvRecommendations = success;
              notifyListeners();
        }
    );
  }
}