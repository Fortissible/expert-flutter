import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TvRepository,
  TvLocalDataSource,
  TvRemoteDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<Dio>(as: #MockDio)
])
void main() {}
