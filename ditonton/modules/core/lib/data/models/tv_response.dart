import 'package:core/core.dart';

class TvResponse{
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
}