import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/bloc_utils/season_util.dart';
import 'package:tvseries/tvseries.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendation,
  GetWatchListTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv
])
void main(){
  final TvDetailState stateInit = TvDetailState(
      tvRecommendations: const [],
      tvSeasons: Seasons(
          expandedValue: const ["Season 0 - 0 Episodes"],
          headerValue: "0 Seasons"
      )
  );
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendation mockGetTvRecommendation;
  late MockGetWatchListTvStatus mockGetWatchListTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp((){
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendation = MockGetTvRecommendation();
    mockGetWatchListTvStatus = MockGetWatchListTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    bloc = TvDetailBloc(
        mockGetTvDetail,
        mockGetTvRecommendation,
        mockGetWatchListTvStatus,
        mockRemoveWatchlistTv,
        mockSaveWatchlistTv,
    );
  });

  const testId = 94954;

  void arrangeUseCase({
    bool isSuccessDetail = true,
    bool isSuccessRecommendation = true,
    bool isEmpty = false
  }){
    when(mockGetTvDetail.execute(testId.toString()))
        .thenAnswer((_) async => isSuccessDetail
        ? Right(testTvDetail)
        : const Left(ServerFailure('Server Failure')));
    when(mockGetTvRecommendation.execute(testId.toString()))
        .thenAnswer((_) async => isSuccessRecommendation
        ? isEmpty
          ? const Right([])
          : Right(testTvList)
        : const Left(ServerFailure('Server Failure')));
  }

  group('Get TV Series Detail and Recommendations', () {
    test("Initial state should be request.empty", (){
      expect(bloc.state.tvRecommendationState, RequestState.Empty);
      expect(bloc.state.tvDetailState, RequestState.Empty);
    });

    blocTest('should execute usecase when try to fetch detail',
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTvDetail(tvId: testId)),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetTvDetail.execute(testId.toString()));
          verify(mockGetTvRecommendation.execute(testId.toString()));
        }
    );

    blocTest('should emit state detail [Loading, Loaded] and'
        'emit state recommendation [Loading,Loaded] when usecase is called',
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add( const FetchTvDetail(tvId: testId) ),
        expect: () => [
          stateInit.copyWith(
            tvDetailState: RequestState.Loading,
          ),
          stateInit.copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationState: RequestState.Loading,
            tvSeasons: generateSeasonFromDetail(testTvDetail.seasons)
          ),
          stateInit.copyWith(
              tvDetailState: RequestState.Loaded,
              tvDetail: testTvDetail,
              tvRecommendationState: RequestState.Loaded,
              tvRecommendations: testTvList,
              tvSeasons: generateSeasonFromDetail(testTvDetail.seasons),
          ),
        ],
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetTvDetail.execute(testId.toString()));
          verify(mockGetTvRecommendation.execute(testId.toString()));
        }
    );

    blocTest('should emit state detail [Loading, Loaded] and'
        'emit state recommendation [Loading,Empty] '
        'when recommendations is empty',
        build: () {
          arrangeUseCase(isEmpty: true);
          return bloc;
        },
        act: (bloc) => bloc.add( const FetchTvDetail(tvId: testId) ),
        expect: () => [
          stateInit.copyWith(
            tvDetailState: RequestState.Loading,
          ),
          stateInit.copyWith(
              tvDetailState: RequestState.Loaded,
              tvDetail: testTvDetail,
              tvRecommendationState: RequestState.Loading,
              tvSeasons: generateSeasonFromDetail(testTvDetail.seasons)
          ),
          stateInit.copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationState: RequestState.Empty,
            tvRecommendations: [],
            tvSeasons: generateSeasonFromDetail(testTvDetail.seasons),
          ),
        ],
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetTvDetail.execute(testId.toString()));
          verify(mockGetTvRecommendation.execute(testId.toString()));
        }
    );

    blocTest('should emit state detail [Loading, Error]'
        'when details is Error',
        build: () {
          arrangeUseCase(isSuccessDetail: false);
          return bloc;
        },
        act: (bloc) => bloc.add( const FetchTvDetail(tvId: testId) ),
        expect: () => [
          stateInit.copyWith(
            tvDetailState: RequestState.Loading,
          ),
          stateInit.copyWith(
              tvDetailState: RequestState.Error,
              tvDetailMsg:  'Server Failure'
          ),
        ],
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetTvDetail.execute(testId.toString()));
          verify(mockGetTvRecommendation.execute(testId.toString()));
        }
    );

    blocTest('should emit state detail [Loading, Loaded]'
        'and emit state recommendation [Loading, Error] when recom is Error',
        build: () {
          arrangeUseCase(isSuccessDetail: true, isSuccessRecommendation: false);
          return bloc;
        },
        act: (bloc) => bloc.add( const FetchTvDetail(tvId: testId) ),
        expect: () => [
          stateInit.copyWith(
            tvDetailState: RequestState.Loading,
          ),
          stateInit.copyWith(
              tvDetailState: RequestState.Loaded,
              tvDetail: testTvDetail,
              tvRecommendationState: RequestState.Loading,
              tvSeasons: generateSeasonFromDetail(testTvDetail.seasons)
          ),
          stateInit.copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationState: RequestState.Error,
            tvRecommendationMsg: 'Server Failure',
            tvSeasons: generateSeasonFromDetail(testTvDetail.seasons),
          ),
        ],
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetTvDetail.execute(testId.toString()));
          verify(mockGetTvRecommendation.execute(testId.toString()));
        }
    );
  });

  void arrangeUseCaseWatchlist({
    bool isGetStatusSuccess = true,
    bool isSaveSuccess = true,
    bool isRemoveSuccess = true
  }){
    when(mockSaveWatchlistTv.execute(testTvDetail))
        .thenAnswer((_) async => isSaveSuccess
        ? const Right('Added to TV Series Watchlist')
        : const Left(DatabaseFailure('DB Failure')));
    when(mockRemoveWatchlistTv.execute(testTvDetail))
        .thenAnswer((_) async => isRemoveSuccess
        ? const Right('Removed from TV Series Watchlist')
        : const Left(DatabaseFailure('DB Failure')));
    when(mockGetWatchListTvStatus.execute(testId))
        .thenAnswer((_) async => isGetStatusSuccess
        ? true
        : false
      );
  }

  group ('Watchlist usecase', (){

    blocTest('should execute usecase when try to get watchlist',
        build: () {
          arrangeUseCaseWatchlist();
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadTvWatchlist(tvId: testId)),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetWatchListTvStatus.execute(testId));
        }
    );

    blocTest('should change the tvwatchlist status when get success',
        build: () {
          arrangeUseCaseWatchlist();
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadTvWatchlist(tvId: testId)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          stateInit.copyWith(
              tvWatchlistStatus: true
          )
        ],
        verify: (bloc){
          verify(mockGetWatchListTvStatus.execute(testId));
        }
    );

    blocTest('should execute add watchlist usecase '
        'when try to add new watchlist tv',
        build: () {
          arrangeUseCaseWatchlist();
          return bloc;
        },
        act: (bloc) => bloc.add(AddTvWatchlist(tv: testTvDetail)),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockSaveWatchlistTv.execute(testTvDetail));
        }
    );

    blocTest('should get save success msg status when saving is success',
        build: () {
          arrangeUseCaseWatchlist();
          return bloc;
        },
        act: (bloc) => bloc.add(AddTvWatchlist(tv: testTvDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          stateInit.copyWith(
              tvWatchlistMsg: 'Added to TV Series Watchlist'
          ),
          stateInit.copyWith(
              tvWatchlistMsg: 'Added to TV Series Watchlist',
              tvWatchlistStatus: true
          )
        ],
        verify: (bloc){
          verify(mockSaveWatchlistTv.execute(testTvDetail));
          verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
        }
    );

    blocTest('should get failed msg status when saving is failing',
        build: () {
          arrangeUseCaseWatchlist(isSaveSuccess: false);
          when(mockGetWatchListTvStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => false
          );
          return bloc;
        },
        act: (bloc) => bloc.add(AddTvWatchlist(tv: testTvDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          stateInit.copyWith(
              tvWatchlistMsg: 'DB Failure',
          ),
        ],
        verify: (bloc){
          verify(mockSaveWatchlistTv.execute(testTvDetail));
          verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
        }
    );

    blocTest('should execute remove watchlist usecase '
        'when try to remove consisting watchlist tv',
        build: () {
          arrangeUseCaseWatchlist();
          return bloc;
        },
        act: (bloc) => bloc.add(RemoveTvWatchlist(tv: testTvDetail)),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockRemoveWatchlistTv.execute(testTvDetail));
          verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
        }
    );

    blocTest('should get remove success msg status when removing is success',
        build: () {
          arrangeUseCaseWatchlist();
          when(mockGetWatchListTvStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => false
          );
          return bloc;
        },
        act: (bloc) => bloc.add(RemoveTvWatchlist(tv: testTvDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          stateInit.copyWith(
              tvWatchlistMsg: 'Removed from TV Series Watchlist'
          ),
        ],
        verify: (bloc){
          verify(mockRemoveWatchlistTv.execute(testTvDetail));
          verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
        }
    );

    blocTest('should get failed msg status when removing is failing',
        build: () {
          arrangeUseCaseWatchlist(isRemoveSuccess: false);
          when(mockGetWatchListTvStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => true
          );
          return bloc;
        },
        act: (bloc) => bloc.add(RemoveTvWatchlist(tv: testTvDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          stateInit.copyWith(
              tvWatchlistMsg: 'DB Failure'
          ),
          stateInit.copyWith(
              tvWatchlistMsg: 'DB Failure',
              tvWatchlistStatus: true
          )
        ],
        verify: (bloc){
          verify(mockRemoveWatchlistTv.execute(testTvDetail));
          verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
        }
    );
  });
}