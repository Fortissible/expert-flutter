import 'package:core/core.dart';

class TvSeasonDetailModel {
  String? id;
  List<EpisodeModel>? episodes;
  String? name;
  String? overview;
  int? tvSeasonDetailModelId;
  dynamic posterPath;

  TvSeasonDetailModel({
    this.id,
    this.episodes,
    this.name,
    this.overview,
    this.tvSeasonDetailModelId,
    this.posterPath,
  });

  factory TvSeasonDetailModel.fromJson(Map<String, dynamic> json) => TvSeasonDetailModel(
    id: json["_id"],
    episodes: json["episodes"] == null ? [] : List<EpisodeModel>
        .from(json["episodes"]!
        .map((x) => EpisodeModel.fromJson(x))),
    name: json["name"],
    overview: json["overview"],
    tvSeasonDetailModelId: json["id"],
    posterPath: json["poster_path"],
  );

  TvSeasonDetail toEntity() => TvSeasonDetail(
    id: id,
    episodes: episodes!.map(
            (episode) => EpisodeEntity(
              episodeNumber: episode.episodeNumber,
              name: episode.name,
              runtime: episode.runtime
            )
    ).toList(),
    name: name,
  );
}

class EpisodeModel {
  DateTime? airDate;
  int? episodeNumber;
  EpisodeTypeModel? episodeType;
  int? id;
  String? name;
  String? overview;
  String? productionCode;
  int? runtime;
  int? seasonNumber;
  int? showId;
  dynamic stillPath;
  double? voteAverage;
  int? voteCount;
  List<dynamic>? crew;
  List<dynamic>? guestStars;

  EpisodeModel({
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

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
    airDate: json["air_date"] == null ? null : DateTime.parse(json["air_date"]),
    episodeNumber: json["episode_number"],
    episodeType: episodeTypeValues.map[json["episode_type"]]!,
    id: json["id"],
    name: json["name"],
    overview: json["overview"],
    productionCode: json["production_code"],
    runtime: json["runtime"],
    seasonNumber: json["season_number"],
    showId: json["show_id"],
    stillPath: json["still_path"],
    voteCount: json["vote_count"],
    crew: json["crew"] == null ? [] : List<dynamic>.from(json["crew"]!.map((x) => x)),
    guestStars: json["guest_stars"] == null ? [] : List<dynamic>.from(json["guest_stars"]!.map((x) => x)),
  );

}

enum EpisodeTypeModel {
  FINALE,
  STANDARD
}

final episodeTypeValues = EnumValues({
  "finale": EpisodeTypeModel.FINALE,
  "standard": EpisodeTypeModel.STANDARD
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);
}
