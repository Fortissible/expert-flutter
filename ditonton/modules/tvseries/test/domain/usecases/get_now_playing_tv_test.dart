import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetNowPlayingTv(repository: mockTvRepository);
  });

  void verifyRepository(){
    verify(mockTvRepository.getNowPlayingTvSeries());
  }

  test('should get list of now playing tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getNowPlayingTvSeries())
        .thenAnswer((_) async => Right(testTvList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvList));
    verifyRepository;
  });
}