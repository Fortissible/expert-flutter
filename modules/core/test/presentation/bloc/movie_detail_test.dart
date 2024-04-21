import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main(){
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendation;
  late MockGetWatchListStatus mockGetWatchListMovieStatus;
  late MockSaveWatchlist mockSaveWatchlistMovie;
  late MockRemoveWatchlist mockRemoveWatchlistMovie;

  setUp((){
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendation = MockGetMovieRecommendations();
    mockGetWatchListMovieStatus = MockGetWatchListStatus();
    mockSaveWatchlistMovie = MockSaveWatchlist();
    mockRemoveWatchlistMovie = MockRemoveWatchlist();
    bloc = MovieDetailBloc(
      mockGetMovieDetail,
      mockGetMovieRecommendation,
      mockGetWatchListMovieStatus,
      mockRemoveWatchlistMovie,
      mockSaveWatchlistMovie,
    );
  });

  const testId = 94954;

  void arrangeUseCase({
    bool isSuccessDetail = true,
    bool isSuccessRecommendation = true,
    bool isEmpty = false
  }){
    when(mockGetMovieDetail.execute(testId))
        .thenAnswer((_) async => isSuccessDetail
        ? Right(testMovieDetail)
        : const Left(ServerFailure('Server Failure')));
    when(mockGetMovieRecommendation.execute(testId))
        .thenAnswer((_) async => isSuccessRecommendation
        ? isEmpty
          ? const Right([])
          : Right(testMovieList)
        : const Left(ServerFailure('Server Failure')));
  }

  group('Get Movies Detail and Recommendations', () {
    test("Initial state should be request.empty", (){
      expect(bloc.state.movieRecommendationState, RequestState.Empty);
      expect(bloc.state.movieDetailState, RequestState.Empty);
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
        'should execute usecase when try to fetch detail',
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMovieDetail(movieId: testId)),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetMovieDetail.execute(testId));
          verify(mockGetMovieRecommendation.execute(testId));
        }
    );

    blocTest('should emit state detail [Loading, Loaded] and'
        'emit state recommendation [Loading,Loaded] when usecase is called',
        build: () {
          arrangeUseCase();
          return bloc;
        },
        act: (bloc) => bloc.add( const FetchMovieDetail(movieId: testId) ),
        expect: () => [
          const MovieDetailState().copyWith(
            movieDetailState: RequestState.Loading,
          ),
          const MovieDetailState().copyWith(
              movieDetailState: RequestState.Loaded,
              movieDetail: testMovieDetail,
              movieRecommendationState: RequestState.Loading
          ),
          const MovieDetailState().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.Loaded,
            movieRecommendations: testMovieList,
          ),
        ],
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetMovieDetail.execute(testId));
          verify(mockGetMovieRecommendation.execute(testId));
        }
    );

    blocTest('should emit state detail [Loading, Loaded] and'
        'emit state recommendation [Loading,Empty] '
        'when recommendations is empty',
        build: () {
          arrangeUseCase(isEmpty: true);
          return bloc;
        },
        act: (bloc) => bloc.add( const FetchMovieDetail(movieId: testId) ),
        expect: () => [
          const MovieDetailState().copyWith(
            movieDetailState: RequestState.Loading,
          ),
          const MovieDetailState().copyWith(
              movieDetailState: RequestState.Loaded,
              movieDetail: testMovieDetail,
              movieRecommendationState: RequestState.Loading
          ),
          const MovieDetailState().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.Empty,
            movieRecommendations: [],
          ),
        ],
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetMovieDetail.execute(testId));
          verify(mockGetMovieRecommendation.execute(testId));
        }
    );

    blocTest('should emit state detail [Loading, Error]'
        'when details is Error',
        build: () {
          arrangeUseCase(isSuccessDetail: false);
          return bloc;
        },
        act: (bloc) => bloc.add( const FetchMovieDetail(movieId: testId) ),
        expect: () => [
          const MovieDetailState().copyWith(
            movieDetailState: RequestState.Loading,
          ),
          const MovieDetailState().copyWith(
              movieDetailState: RequestState.Error,
              movieDetailMsg:  'Server Failure'
          ),
        ],
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetMovieDetail.execute(testId));
          verify(mockGetMovieRecommendation.execute(testId));
        }
    );

    blocTest('should emit state detail [Loading, Loaded]'
        'and emit state recommendation [Loading, Error] when recom is Error',
        build: () {
          arrangeUseCase(isSuccessDetail: true, isSuccessRecommendation: false);
          return bloc;
        },
        act: (bloc) => bloc.add( const FetchMovieDetail(movieId: testId) ),
        expect: () => [
          const MovieDetailState().copyWith(
            movieDetailState: RequestState.Loading,
          ),
          const MovieDetailState().copyWith(
              movieDetailState: RequestState.Loaded,
              movieDetail: testMovieDetail,
              movieRecommendationState: RequestState.Loading,
          ),
          const MovieDetailState().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.Error,
            movieRecommendationMsg: 'Server Failure',
          ),
        ],
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetMovieDetail.execute(testId));
          verify(mockGetMovieRecommendation.execute(testId));
        }
    );
  });

  void arrangeUseCaseWatchlist({
    bool isGetStatusSuccess = true,
    bool isSaveSuccess = true,
    bool isRemoveSuccess = true
  }){
    when(mockSaveWatchlistMovie.execute(testMovieDetail))
        .thenAnswer((_) async => isSaveSuccess
        ? const Right('Added to Movies Watchlist')
        : const Left(DatabaseFailure('DB Failure')));
    when(mockRemoveWatchlistMovie.execute(testMovieDetail))
        .thenAnswer((_) async => isRemoveSuccess
        ? const Right('Removed Movies Watchlist')
        : const Left(DatabaseFailure('DB Failure')));
    when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
        .thenAnswer((_) async => isGetStatusSuccess
        ? true
        : false
    );
    when(mockGetWatchListMovieStatus.execute(testId))
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
        act: (bloc) => bloc.add(const LoadWatchlistMovie(movieId: testId)),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockGetWatchListMovieStatus.execute(testId));
        }
    );

    blocTest('should change the Moviewatchlist status when get success',
        build: () {
          arrangeUseCaseWatchlist();
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadWatchlistMovie(movieId: testId)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieDetailState().copyWith(
              movieWatchlistStatus: true
          )
        ],
        verify: (bloc){
          verify(mockGetWatchListMovieStatus.execute(testId));
        }
    );

    blocTest('should execute add watchlist usecase '
        'when try to add new watchlist Movie',
        build: () {
          arrangeUseCaseWatchlist();
          return bloc;
        },
        act: (bloc) => bloc.add(AddWatchlistMovie(movieDetail: testMovieDetail)),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        }
    );

    blocTest('should get save success msg status when saving is success',
        build: () {
          arrangeUseCaseWatchlist();
          return bloc;
        },
        act: (bloc) => bloc.add(AddWatchlistMovie(movieDetail: testMovieDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieDetailState().copyWith(
              movieWatchlistMsg: 'Added to Movies Watchlist'
          ),
          const MovieDetailState().copyWith(
              movieWatchlistMsg: 'Added to Movies Watchlist',
              movieWatchlistStatus: true
          )
        ],
        verify: (bloc){
          verify(mockSaveWatchlistMovie.execute(testMovieDetail));
          verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
        }
    );

    blocTest('should get failed msg status when saving is failing',
        build: () {
          arrangeUseCaseWatchlist(isSaveSuccess: false);
          when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false
          );
          return bloc;
        },
        act: (bloc) => bloc.add(AddWatchlistMovie(movieDetail: testMovieDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieDetailState().copyWith(
            movieWatchlistMsg: 'DB Failure',
          ),
        ],
        verify: (bloc){
          verify(mockSaveWatchlistMovie.execute(testMovieDetail));
          verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
        }
    );

    blocTest('should execute remove watchlist usecase '
        'when try to remove consisting watchlist Movie',
        build: () {
          arrangeUseCaseWatchlist();
          return bloc;
        },
        act: (bloc) => bloc.add(RemoveWatchlistMovie(movieDetail: testMovieDetail)),
        wait: const Duration(milliseconds: 100),
        verify: (bloc){
          verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
          verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
        }
    );

    blocTest('should get remove success msg status when removing is success',
        build: () {
          arrangeUseCaseWatchlist();
          when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false
          );
          return bloc;
        },
        act: (bloc) => bloc.add(RemoveWatchlistMovie(movieDetail: testMovieDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieDetailState().copyWith(
              movieWatchlistMsg: 'Removed Movies Watchlist'
          ),
        ],
        verify: (bloc){
          verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
          verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
        }
    );

    blocTest('should get failed msg status when removing is failing',
        build: () {
          arrangeUseCaseWatchlist(isRemoveSuccess: false);
          when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => true
          );
          return bloc;
        },
        act: (bloc) => bloc.add(RemoveWatchlistMovie(movieDetail: testMovieDetail)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const MovieDetailState().copyWith(
              movieWatchlistMsg: 'DB Failure'
          ),
          const MovieDetailState().copyWith(
              movieWatchlistMsg: 'DB Failure',
              movieWatchlistStatus: true
          )
        ],
        verify: (bloc){
          verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
          verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
        }
    );
  });
}


