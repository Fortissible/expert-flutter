// Mocks generated by Mockito 5.4.4 from annotations
// in ditonton/test/presentation/pages/tv_season_detail_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:ui' as _i7;

import 'package:ditonton/common/state_enum.dart' as _i4;
import 'package:ditonton/domain/usecases/get_tv_season_detail.dart' as _i2;
import 'package:ditonton/presentation/provider/tv_season_detail_notifier.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;

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

class _FakeGetTvSeasonDetail_0 extends _i1.SmartFake
    implements _i2.GetTvSeasonDetail {
  _FakeGetTvSeasonDetail_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TvSeasonDetailNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockTvSeasonDetailNotifier extends _i1.Mock
    implements _i3.TvSeasonDetailNotifier {
  MockTvSeasonDetailNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetTvSeasonDetail get getTvSeasonDetail => (super.noSuchMethod(
        Invocation.getter(#getTvSeasonDetail),
        returnValue: _FakeGetTvSeasonDetail_0(
          this,
          Invocation.getter(#getTvSeasonDetail),
        ),
      ) as _i2.GetTvSeasonDetail);

  @override
  _i4.RequestState get tvSeasonDetailState => (super.noSuchMethod(
        Invocation.getter(#tvSeasonDetailState),
        returnValue: _i4.RequestState.Empty,
      ) as _i4.RequestState);

  @override
  String get tvSeasonDetailErrorMsg => (super.noSuchMethod(
        Invocation.getter(#tvSeasonDetailErrorMsg),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.getter(#tvSeasonDetailErrorMsg),
        ),
      ) as String);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  _i6.Future<void> fetchTvSeasonDetail(
    String? id,
    String? seasonId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchTvSeasonDetail,
          [
            id,
            seasonId,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  void addListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
