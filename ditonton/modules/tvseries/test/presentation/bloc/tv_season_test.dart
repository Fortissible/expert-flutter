import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_season_test.mocks.dart';

@GenerateMocks([GetTvSeasonDetail])
void main(){
  late TvSeasonBloc bloc;
  late MockGetTvSeasonDetail mockGetTvSeasonDetail;

  setUp((){
    mockGetTvSeasonDetail = MockGetTvSeasonDetail();
    bloc = TvSeasonBloc(mockGetTvSeasonDetail);
  });

  const testId = "1";
  const testSeasonId = "1";

  void arrangeUseCase({bool isSuccess = true}){
    when(mockGetTvSeasonDetail.execute(testId, testSeasonId))
        .thenAnswer((_) async => isSuccess
        ? Right(testSeasonDetail)
        : const Left(ServerFailure('Server Failure')));
  }

  group("Tv Season Detail", (){
    test("should request state empty if the state is init", () async {
      expect(bloc.state.tvSeasonState, RequestState.Empty);
    });

    blocTest<TvSeasonBloc, TvSeasonState>(
        "State should Should emit [Loading, Error] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase(isSuccess: false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTvSeason(
            tvId: testId,
            seasonId: testSeasonId
        )),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const TvSeasonState().copyWith(
              tvSeasonState: RequestState.Loading
          ),
          const TvSeasonState().copyWith(
              tvSeasonState: RequestState.Error,
              tvSeasonMsg: 'Server Failure'
          ),
        ],
        verify: (bloc){
          verify(mockGetTvSeasonDetail.execute(testId, testSeasonId));
        }
    );

    blocTest<TvSeasonBloc, TvSeasonState>(
        "State should Should emit [Loading, Loaded] "
            "when try to fetching from remote data source",
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTvSeason(
            tvId: testId,
            seasonId: testSeasonId
        )),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const TvSeasonState().copyWith(
              tvSeasonState: RequestState.Loading
          ),
          const TvSeasonState().copyWith(
              tvSeasonState: RequestState.Loaded,
              tvSeason: testSeasonDetail
          ),
        ],
        verify: (bloc){
          verify(mockGetTvSeasonDetail.execute(testId, testSeasonId));
        }
    );
  });
}