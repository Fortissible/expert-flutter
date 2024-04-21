import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeasonDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvSeasonDetail(repository: mockTvRepository);
  });

  final testId = 94954.toString();
  const testSeasonId = "1";

  void verifyRepository(){
    verify(mockTvRepository.getSeasonDetailTvSeries(testId, testSeasonId));
  }

  test('should get season detail of a tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getSeasonDetailTvSeries(testId, testSeasonId))
        .thenAnswer((_) async => Right(testSeasonDetail));
    // act
    final result = await usecase.execute(testId, testSeasonId);
    // assert
    expect(result, Right(testSeasonDetail));
    verifyRepository;
  });
}