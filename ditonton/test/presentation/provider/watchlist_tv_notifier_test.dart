import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main(){
  late WatchlistTvNotifier provider;
  late MockGetWatchlistTv mockGetWatchlistTv;
  setUp((){
    mockGetWatchlistTv = MockGetWatchlistTv();
    provider = WatchlistTvNotifier(getWatchlistTv: mockGetWatchlistTv);
  });

  void _arrangeUseCase({bool isSuccess = true}){
    when(mockGetWatchlistTv.execute())
        .thenAnswer((_) async => isSuccess
          ? Right([testTvWatchlist])
          : Left(DatabaseFailure("Can't get data"))
    );
  }

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    _arrangeUseCase();
    // act
    await provider.fetchWatchlistTv();
    // assert
    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlistTv, [testTvWatchlist]);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    _arrangeUseCase(isSuccess: false);
    // act
    await provider.fetchWatchlistTv();
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
  });
}