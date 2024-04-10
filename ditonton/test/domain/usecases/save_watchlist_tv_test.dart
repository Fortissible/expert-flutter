import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlistTv(mockTvRepository);
  });

  void _verifyRepository(){
    verify(mockTvRepository.insertWatchlistTv(testTvDetail));
  }

  test('should save tv series watchlist from the repository', () async {
    // arrange
    when(mockTvRepository.insertWatchlistTv(testTvDetail))
        .thenAnswer((_) async => Right("Success"));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    expect(result, Right("Success"));
    _verifyRepository;
  });
}