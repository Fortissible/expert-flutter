import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListTvStatus usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchListTvStatus(mockTvRepository);
  });

  const testId = 94954;

  void verifyRepository(){
    verify(mockTvRepository.isAddedToWatchlist(testId));
  }

  test('should get status watchlist of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.isAddedToWatchlist(testId))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(testId);
    // assert
    expect(result, true);
    verifyRepository;
  });
}