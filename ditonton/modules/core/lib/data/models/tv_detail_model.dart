import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_detail.dart' as ent;

class TvDetailModel extends Equatable {
  final bool adult;
  final String backdropPath;
  final List<dynamic> createdBy;
  final List<int> episodeRunTime;
  final List<TvDetailModelGenre> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String name;
  final dynamic nextEpisodeToAir;
  final List<Network> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<Network> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final List<Season> seasons;
  final List<SpokenLanguage> spokenLanguages;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  TvDetailModel({
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
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.seasons,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    createdBy: List<dynamic>.from(json["created_by"].map((x) => x)),
    episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
    genres: List<TvDetailModelGenre>.from(json["genres"].map((x) => TvDetailModelGenre.fromJson(x))),
    homepage: json["homepage"],
    id: json["id"],
    inProduction: json["in_production"],
    languages: List<String>.from(json["languages"].map((x) => x)),
    name: json["name"],
    nextEpisodeToAir: json["next_episode_to_air"],
    networks: List<Network>.from(json["networks"].map((x) => Network.fromJson(x))),
    numberOfEpisodes: json["number_of_episodes"],
    numberOfSeasons: json["number_of_seasons"],
    originalLanguage: json["original_language"],
    originalName: json["original_name"],
    overview: json["overview"],
    popularity: json["popularity"]?.toDouble(),
    posterPath: json["poster_path"],
    productionCompanies: List<Network>.from(json["production_companies"].map((x) => Network.fromJson(x))),
    productionCountries: List<ProductionCountry>.from(json["production_countries"].map((x) => ProductionCountry.fromJson(x))),
    seasons: List<Season>.from(json["seasons"].map((x) => Season.fromJson(x))),
    spokenLanguages: List<SpokenLanguage>.from(json["spoken_languages"].map((x) => SpokenLanguage.fromJson(x))),
    status: json["status"],
    tagline: json["tagline"],
    type: json["type"],
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
  );

  TvDetail toEntity() => TvDetail(
      adult: adult,
      backdropPath: backdropPath,
      createdBy: createdBy,
      episodeRunTime: episodeRunTime,
      genres: genres.map(
              (genre) => TvDetailGenre(id: genre.id, name: genre.name)
      ).toList(),
      homepage: homepage,
      id: id,
      inProduction: inProduction,
      languages: languages,
      name: name,
      nextEpisodeToAir: nextEpisodeToAir,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      originalLanguage: originalLanguage,
      originalName: originalName,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      productionCountries: productionCountries.map(
              (prodsCountry) => ProductionCountryEntity(
                  iso31661: prodsCountry.iso31661 == OriginCountry.JP
                      ? ent.OriginCountryEntity.JP
                      : prodsCountry.iso31661 == OriginCountry.KR
                        ? ent.OriginCountryEntity.KR
                        : ent.OriginCountryEntity.US,
                  name: prodsCountry.name
              )
      ).toList(),
      seasons: seasons.map(
              (season) => ent.SeasonEntity(
                  airDate: season.airDate,
                  episodeCount: season.episodeCount,
                  id: season.id,
                  name: season.name,
                  overview: season.overview,
                  posterPath: season.posterPath,
                  seasonNumber: season.seasonNumber,
                  voteAverage: season.voteAverage
              )
      ).toList(),
      spokenLanguages: spokenLanguages.map(
              (spokenLang) => ent.SpokenLanguageEntity(
                  englishName: spokenLang.englishName,
                  iso6391: spokenLang.iso6391,
                  name: spokenLang.name
              )
      ).toList(),
      status: status,
      tagline: tagline,
      type: type,
      voteAverage: voteAverage,
      voteCount: voteCount
  );

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
    networks,
    numberOfEpisodes,
    numberOfSeasons,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    productionCompanies,
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

class TvDetailModelGenre extends Equatable{
  final int id;
  final String name;

  TvDetailModelGenre({
    required this.id,
    required this.name,
  });

  factory TvDetailModelGenre.fromJson(Map<String, dynamic> json) => TvDetailModelGenre(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  @override
  List<Object?> get props => [id, name];
}

class LastEpisodeToAir {
  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final DateTime airDate;
  final int episodeNumber;
  final String episodeType;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;

  LastEpisodeToAir({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.airDate,
    required this.episodeNumber,
    required this.episodeType,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
  });
}

class Network extends Equatable{
  final int id;
  final String? logoPath;
  final String name;
  final OriginCountry? originCountry;

  Network({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory Network.fromJson(Map<String, dynamic> json) => Network(
    id: json["id"],
    logoPath: json["logo_path"],
    name: json["name"],
    originCountry: originCountryValues.map[json["origin_country"]],
  );

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    logoPath,
    name,
    originCountry
  ];
}

enum OriginCountry {
  JP,
  KR,
  US
}

final originCountryValues = EnumValuesTvDetailModel({
  "JP": OriginCountry.JP,
  "KR": OriginCountry.KR,
  "US": OriginCountry.US
});

class ProductionCountry extends Equatable{
  final OriginCountry? iso31661;
  final String name;

  ProductionCountry({
    required this.iso31661,
    required this.name,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) => ProductionCountry(
    iso31661: originCountryValues.map[json["iso_3166_1"]],
    name: json["name"],
  );

  @override
  List<Object?> get props => [name, iso31661];
}

class Season extends Equatable{
  final DateTime? airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  Season({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
    airDate: json["air_date"] != null ? DateTime.parse(json["air_date"]) : null,
    episodeCount: json["episode_count"],
    id: json["id"],
    name: json["name"],
    overview: json["overview"],
    posterPath: json["poster_path"],
    seasonNumber: json["season_number"],
    voteAverage: json["vote_average"]?.toDouble(),
  );

  @override
  // TODO: implement props
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

class SpokenLanguage extends Equatable{
  final String englishName;
  final String iso6391;
  final String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
    englishName: json["english_name"],
    iso6391: json["iso_639_1"],
    name: json["name"],
  );

  @override
  // TODO: implement props
  List<Object?> get props => [
    englishName,
    name,
    iso6391
  ];
}

class EnumValuesTvDetailModel<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValuesTvDetailModel(this.map);
}
