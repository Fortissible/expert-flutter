import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTv(repository: mockTvRepository);
  });

  final testQuery = "morty";

  void _verifyRepository(){
    verify(mockTvRepository.searchTvSeries(testQuery));
  }

  test('should search tv series from the repository', () async {
    // arrange
    when(mockTvRepository.searchTvSeries(testQuery))
        .thenAnswer((_) async => Right(testTvList));
    // act
    final result = await usecase.execute(testQuery);
    // assert
    expect(result, Right(testTvList));
    _verifyRepository;
  });
}