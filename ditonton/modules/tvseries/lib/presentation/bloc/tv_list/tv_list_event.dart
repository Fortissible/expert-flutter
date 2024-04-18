part of 'tv_list_bloc.dart';

abstract class TvListEvent extends Equatable {
  const TvListEvent();

  @override
  List<Object?> get props => [];
}

class FetchOnAirTv extends TvListEvent {
  const FetchOnAirTv();
}

class FetchPopularTv extends TvListEvent {
  const FetchPopularTv();
}

class FetchTopRatedTv extends TvListEvent {
  const FetchTopRatedTv();
}