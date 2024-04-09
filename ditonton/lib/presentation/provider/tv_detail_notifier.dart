import 'package:ditonton/data/models/seasons.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendation.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter/cupertino.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import '../../domain/usecases/get_watchlist_tv_status.dart';

class TvDetailNotifier extends ChangeNotifier {
  final GetTvDetail getTvDetail;
  final GetTvRecommendation getTvRecommendation;
  final GetWatchListTvStatus getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to TV Series Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from TV Series Watchlist';

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

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Seasons _seasons = Seasons(
      expandedValue: ["Season 0 - 0 Episodes"],
      headerValue: "0 Seasons"
  );
  Seasons get seasons => _seasons;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendation,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist
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
              List<String> expandedValue = [];
              for(var i = 0; i < success.seasons.length; i++){
                expandedValue.add("• Season ${i+1} - ${success.seasons[i].episodeCount} Episode\n");
              }
              _seasons = Seasons(
                  expandedValue: expandedValue,
                  headerValue: "${success.seasons.length} Seasons"
              );
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
    final result = await getTvRecommendation.execute(id);
    result.fold(
            (failure) {
              _tvRecommendationState = RequestState.Error;
              _tvRecommendationsErrorMsg = failure.message;
              notifyListeners();
        },
          (success) {
              print(success);
              _tvRecommendationState = RequestState.Loaded;
              _tvRecommendations = success;
              notifyListeners();
        }
    );
  }

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlist.execute(tv);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlist.execute(tv);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }

  void expandSeasonsDetail(bool isExpanded) {
    _seasons.isExpanded = isExpanded;
    notifyListeners();
  }
}