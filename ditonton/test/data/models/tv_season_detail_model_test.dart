import 'dart:convert';

import 'package:ditonton/data/models/tv_season_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tSeasonDetail = TvSeasonDetailModel.fromJson(
      json.decode(readJson('dummy_data/tv_season_detail.json')));

  final tSeasonModel = tSeasonDetail.toEntity();

  test('should be a subclass of Season Model entity', () async {
    final result = tSeasonDetail.toEntity();
    expect(result, equals(tSeasonModel));
  });
}