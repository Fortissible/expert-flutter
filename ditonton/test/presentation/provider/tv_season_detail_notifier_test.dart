import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_season_detail.dart';
import 'package:ditonton/presentation/provider/tv_season_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_season_detail_notifier_test.mocks.dart';

@GenerateMocks([GetTvSeasonDetail])
void main(){
  late TvSeasonDetailNotifier provider;
  late MockGetTvSeasonDetail mockGetTvSeasonDetail;

  setUp((){
    mockGetTvSeasonDetail = MockGetTvSeasonDetail();
    provider = TvSeasonDetailNotifier(getTvSeasonDetail: mockGetTvSeasonDetail);
  });

  final testId = "1";
  final testSeasonId = "1";

  void _arrangeUseCase({bool isSuccess = true}){
    when(mockGetTvSeasonDetail.execute(testId, testSeasonId))
        .thenAnswer((_) async => isSuccess
        ? Right(testSeasonDetail)
        : Left(ServerFailure('Server Failure')));
  }

  group("Tv Season Detail", (){
    test("should execute use case when try to fetch season detail", () async {
      _arrangeUseCase();
      provider.fetchTvSeasonDetail(testId, testSeasonId);
      verify(mockGetTvSeasonDetail.execute(testId, testSeasonId));
    });

    test("should loading state when try to fetch season detail", () {
      _arrangeUseCase();
      provider.fetchTvSeasonDetail(testId, testSeasonId);
      expect(provider.tvSeasonDetailState, RequestState.Loading);
    });

    test("should success state when successfuly fetch season detail", () async {
      _arrangeUseCase();
      await provider.fetchTvSeasonDetail(testId, testSeasonId);
      expect(provider.tvSeasonDetailState, RequestState.Loaded);
      expect(provider.tvSeasonDetail, testSeasonDetail);
    });

    test("should error state when unsuccess fetch season detail", () async {
      _arrangeUseCase(isSuccess: false);
      await provider.fetchTvSeasonDetail(testId, testSeasonId);
      expect(provider.tvSeasonDetailState, RequestState.Error);
      expect(provider.tvSeasonDetail, null);
      expect(provider.tvSeasonDetailErrorMsg, "Server Failure");
    });
  });
}