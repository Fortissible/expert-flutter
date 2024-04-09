import 'dart:convert';

import 'package:ditonton/domain/entities/tv_season_detail.dart' as ent;

TvSeasonDetailModel tvSeasonDetailModelFromJson(String str) => TvSeasonDetailModel.fromJson(json.decode(str));

String tvSeasonDetailModelToJson(TvSeasonDetailModel data) => json.encode(data.toJson());

class TvSeasonDetailModel {
  String? id;
  List<Episode>? episodes;
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
    episodes: json["episodes"] == null ? [] : List<Episode>.from(json["episodes"]!.map((x) => Episode.fromJson(x))),
    name: json["name"],
    overview: json["overview"],
    tvSeasonDetailModelId: json["id"],
    posterPath: json["poster_path"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "episodes": episodes == null ? [] : List<dynamic>.from(episodes!.map((x) => x.toJson())),
    "name": name,
    "overview": overview,
    "id": tvSeasonDetailModelId,
    "poster_path": posterPath,
  };

  ent.TvSeasonDetail toEntity() => ent.TvSeasonDetail(
    id: id,
    episodes: episodes!.map(
            (episode) => ent.Episode(
              episodeNumber: episode.episodeNumber,
              name: episode.name,
              runtime: episode.runtime
            )
    ).toList(),
    name: name,
  );
}

class Episode {
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
  double? voteAverage;
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

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
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
    voteAverage: json["vote_average"],
    voteCount: json["vote_count"],
    crew: json["crew"] == null ? [] : List<dynamic>.from(json["crew"]!.map((x) => x)),
    guestStars: json["guest_stars"] == null ? [] : List<dynamic>.from(json["guest_stars"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "air_date": "${airDate!.year.toString().padLeft(4, '0')}-${airDate!.month.toString().padLeft(2, '0')}-${airDate!.day.toString().padLeft(2, '0')}",
    "episode_number": episodeNumber,
    "episode_type": episodeTypeValues.reverse[episodeType],
    "id": id,
    "name": name,
    "overview": overview,
    "production_code": productionCode,
    "runtime": runtime,
    "season_number": seasonNumber,
    "show_id": showId,
    "still_path": stillPath,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "crew": crew == null ? [] : List<dynamic>.from(crew!.map((x) => x)),
    "guest_stars": guestStars == null ? [] : List<dynamic>.from(guestStars!.map((x) => x)),
  };
}

enum EpisodeType {
  FINALE,
  STANDARD
}

final episodeTypeValues = EnumValues({
  "finale": EpisodeType.FINALE,
  "standard": EpisodeType.STANDARD
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
