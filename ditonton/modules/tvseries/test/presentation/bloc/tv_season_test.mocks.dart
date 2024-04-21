// Mocks generated by Mockito 5.4.4 from annotations
// in tvseries/test/presentation/bloc/tv_season_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:core/core.dart' as _i2;
import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:tvseries/domain/usecases/get_tv_season_detail.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeTvRepository_0 extends _i1.SmartFake implements _i2.TvRepository {
  _FakeTvRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetTvSeasonDetail].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTvSeasonDetail extends _i1.Mock implements _i4.GetTvSeasonDetail {
  MockGetTvSeasonDetail() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TvRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeTvRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.TvRepository);

  @override
  _i5.Future<_i3.Either<_i2.Failure, _i2.TvSeasonDetail>> execute(
    String? tvId,
    String? seasonId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            tvId,
            seasonId,
          ],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i2.Failure, _i2.TvSeasonDetail>>.value(
                _FakeEither_1<_i2.Failure, _i2.TvSeasonDetail>(
          this,
          Invocation.method(
            #execute,
            [
              tvId,
              seasonId,
            ],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i2.Failure, _i2.TvSeasonDetail>>);
}
