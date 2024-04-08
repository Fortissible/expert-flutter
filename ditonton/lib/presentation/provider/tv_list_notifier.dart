import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter/cupertino.dart';

class TvListNotifier extends ChangeNotifier{
  final GetNowPlayingTv getNowPlayingTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  TvListNotifier({
    required this.getTopRatedTv,
    required this.getPopularTv,
    required this.getNowPlayingTv
  });

  //TODO IMPLEMENT TV LIST NOTIFIER
}