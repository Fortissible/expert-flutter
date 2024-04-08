// To parse this JSON data, do
//
//     final tvResponse = tvResponseFromJson(jsonString);

import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:equatable/equatable.dart';

TvResponse tvResponseFromJson(String str) => TvResponse.fromJson(json.decode(str));

String tvResponseToJson(TvResponse data) => json.encode(data.toJson());

class TvResponse extends Equatable{
  final int page;
  final List<TvModel> results;
  final int totalPages;
  final int totalResults;

  TvResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
    page: json["page"],
    results: List<TvModel>.from(json["results"]
        .map((x) => TvModel.fromJson(x)))
        .where(
            (element) => element.backdropPath != null && element.posterPath != null
    ).toList(),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };

  @override
  List<Object?> get props => [page, results, totalPages, totalResults];
}