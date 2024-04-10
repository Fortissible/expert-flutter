import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListTvStatus usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchListTvStatus(mockTvRepository);
  });

  final testId = 94954;

  void _verifyRepository(){
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
    _verifyRepository;
  });
}