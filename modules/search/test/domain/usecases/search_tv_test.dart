import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvUsecase usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTvUsecase(repository: mockTvRepository);
  });

  const testQuery = "morty";

  void verifyRepository(){
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
    verifyRepository;
  });
}