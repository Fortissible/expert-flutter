import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = RemoveWatchlistTv(mockTvRepository);
  });

  void verifyRepository(){
    verify(mockTvRepository.removeWatchlistTv(testTvDetail));
  }

  test('should remove tv series watchlist from the repository', () async {
    // arrange
    when(mockTvRepository.removeWatchlistTv(testTvDetail))
        .thenAnswer((_) async => const Right("Success"));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    expect(result, const Right("Success"));
    verifyRepository;
  });
}