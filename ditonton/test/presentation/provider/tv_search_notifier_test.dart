import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main(){
  late TvSearchNotifier provider;
  late MockSearchTv mockSearchTv;
  setUp((){
    mockSearchTv = MockSearchTv();
    provider = TvSearchNotifier(searchTv: mockSearchTv);
  });

  final testQuery = "morty";

  void _arrangeUseCase({bool isSuccess = true}){
    when(mockSearchTv.execute(testQuery))
        .thenAnswer((_) async => isSuccess
        ? Right(testTvList)
        : Left(ServerFailure('Server Failure')));
  }

  group('search tv series', () {
    test('should trigger usecase when try to search from remote', (){
      // arrange
      _arrangeUseCase();
      // act
      provider.fetchSearchTv(testQuery);
      // assert
      verify(mockSearchTv.execute(testQuery));
    });

    test('should change state to loading when usecase is called', () async {
      // arrange
      _arrangeUseCase();
      // act
      provider.fetchSearchTv(testQuery);
      // assert
      expect(provider.searchState, RequestState.Loading);
    });

    test('should change search result data '
        'when data is gotten successfully', () async {
      // arrange
      _arrangeUseCase();
      // act
      await provider.fetchSearchTv(testQuery);
      // assert
      expect(provider.searchState, RequestState.Loaded);
      expect(provider.searchTvList, testTvList);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      _arrangeUseCase(isSuccess: false);
      // act
      await provider.fetchSearchTv(testQuery);
      // assert
      expect(provider.searchState, RequestState.Error);
      expect(provider.searchTvErrorMsg, 'Server Failure');
    });
  });
}