import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlistTv(mockTvRepository);
  });

  void verifyRepository(){
    verify(mockTvRepository.insertWatchlistTv(testTvDetail));
  }

  test('should save tv series watchlist from the repository', () async {
    // arrange
    when(mockTvRepository.insertWatchlistTv(testTvDetail))
        .thenAnswer((_) async => const Right("Success"));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    expect(result, const Right("Success"));
    verifyRepository;
  });
}