import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendation usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecommendation(repository: mockTvRepository);
  });

  final testId = 94954.toString();

  void verifyRepository(){
    verify(mockTvRepository.getTvRecommendation(testId));
  }

  test('should get list of tv series recommendation from the repository', () async {
    // arrange
    when(mockTvRepository.getTvRecommendation(testId))
        .thenAnswer((_) async => Right(testTvList));
    // act
    final result = await usecase.execute(testId);
    // assert
    expect(result, Right(testTvList));
    verifyRepository;
  });
}