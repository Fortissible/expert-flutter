part of 'tv_search_bloc.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchTv extends TvSearchEvent {
  final String query;
  const SearchTv({
    required this.query
  });
}
