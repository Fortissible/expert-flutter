import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvDetail(repository: mockTvRepository);
  });

  final testId = 94954.toString();

  void _verifyRepository(){
    verify(mockTvRepository.getDetailTvSeries(testId));
  }

  test('should get tv series detail from the repository', () async {
    // arrange
    when(mockTvRepository.getDetailTvSeries(testId))
        .thenAnswer((_) async => Right(testTvDetail));
    // act
    final result = await usecase.execute(testId);
    // assert
    expect(result, Right(testTvDetail));
    _verifyRepository;
  });
}