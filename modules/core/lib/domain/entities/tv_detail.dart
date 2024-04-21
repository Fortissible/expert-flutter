import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  final bool adult;
  final String backdropPath;
  final List<dynamic> createdBy;
  final List<int> episodeRunTime;
  final List<TvDetailGenre> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String name;
  final dynamic nextEpisodeToAir;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<ProductionCountryEntity> productionCountries;
  final List<SeasonEntity> seasons;
  final List<SpokenLanguageEntity> spokenLanguages;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  const TvDetail({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.name,
    required this.nextEpisodeToAir,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCountries,
    required this.seasons,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    createdBy,
    episodeRunTime,
    genres,
    homepage,
    id,
    inProduction,
    languages,
    name,
    nextEpisodeToAir,
    numberOfEpisodes,
    numberOfSeasons,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    productionCountries,
    seasons,
    spokenLanguages,
    status,
    tagline,
    type,
    voteAverage,
    voteCount,
  ];
}



class TvDetailGenre extends Equatable{
  final int id;
  final String name;

  const TvDetailGenre({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [
    id, name
  ];
}

enum OriginCountryEntity {
  JP,
  KR,
  US
}

class ProductionCountryEntity extends Equatable{
  final OriginCountryEntity iso31661;
  final String name;

  const ProductionCountryEntity({
    required this.iso31661,
    required this.name,
  });

  @override
  List<Object?> get props => [
    iso31661, name
  ];
}

class SeasonEntity extends Equatable{
  final DateTime? airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  const SeasonEntity({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  @override
  List<Object?> get props => [
    airDate,
    episodeCount,
    id,
    name,
    overview,
    posterPath,
    seasonNumber,
    voteAverage,
  ];
}

class SpokenLanguageEntity extends Equatable{
  final String englishName;
  final String iso6391;
  final String name;

  const SpokenLanguageEntity({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  @override
  List<Object?> get props => [
    englishName, iso6391, name
  ];
}

class EnumValuesTvDetailEntity<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValuesTvDetailEntity(this.map);
}