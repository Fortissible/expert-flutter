import 'package:equatable/equatable.dart';

class TvSeasonDetail extends Equatable{
  String? id;
  DateTime? airDate;
  List<Episode>? episodes;
  String? name;
  String? overview;
  int? tvSeasonDetailId;
  dynamic posterPath;
  int? seasonNumber;
  int? voteAverage;

  TvSeasonDetail({
    this.id,
    this.airDate,
    this.episodes,
    this.name,
    this.overview,
    this.tvSeasonDetailId,
    this.posterPath,
    this.seasonNumber,
    this.voteAverage,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    airDate,
    episodes,
    name,
    overview,
    tvSeasonDetailId,
    posterPath,
    seasonNumber,
    voteAverage,
  ];

}

class Episode extends Equatable {
  DateTime? airDate;
  int? episodeNumber;
  EpisodeType? episodeType;
  int? id;
  String? name;
  String? overview;
  String? productionCode;
  int? runtime;
  int? seasonNumber;
  int? showId;
  dynamic stillPath;
  int? voteAverage;
  int? voteCount;
  List<dynamic>? crew;
  List<dynamic>? guestStars;

  Episode({
    this.airDate,
    this.episodeNumber,
    this.episodeType,
    this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.runtime,
    this.seasonNumber,
    this.showId,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
    this.crew,
    this.guestStars,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    airDate,
    episodeNumber,
    episodeType,
    id,
    name,
    overview,
    productionCode,
    runtime,
    seasonNumber,
    showId,
    stillPath,
    voteAverage,
    voteCount,
    crew,
    guestStars,
  ];

}

enum EpisodeType {
  FINALE,
  STANDARD
}
