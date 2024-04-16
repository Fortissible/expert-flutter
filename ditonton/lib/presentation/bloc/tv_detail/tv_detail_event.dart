part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable{
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int tvId;

  const FetchTvDetail({
    required this.tvId
  });
}

class AddTvWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const AddTvWatchlist({
    required this.tv
  });
}

class RemoveTvWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const RemoveTvWatchlist({
    required this.tv
  });
}

class LoadTvWatchlist extends TvDetailEvent {
  final int tvId;

  const LoadTvWatchlist({
    required this.tvId
  });
}

class ExpandSeasonDetail extends TvDetailEvent {
  final bool isExpanded;

  const ExpandSeasonDetail({
    required this.isExpanded
  });
}