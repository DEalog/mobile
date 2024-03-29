// Mocks generated by Mockito 5.0.16 from annotations
// in mobile/test/version_unit_test.dart.
// Do not manually edit this file.

import 'package:mobile/app_settings.dart' as _i4;
import 'package:mobile/model/channel.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:package_info/package_info.dart' as _i3;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart'
    as _i2;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeStreamingSharedPreferences_0 extends _i1.Fake
    implements _i2.StreamingSharedPreferences {}

class _FakePreference_1<T> extends _i1.Fake implements _i2.Preference<T> {}

/// A class which mocks [PackageInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockPackageInfo extends _i1.Mock implements _i3.PackageInfo {
  MockPackageInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get appName =>
      (super.noSuchMethod(Invocation.getter(#appName), returnValue: '')
          as String);
  @override
  String get packageName =>
      (super.noSuchMethod(Invocation.getter(#packageName), returnValue: '')
          as String);
  @override
  String get version =>
      (super.noSuchMethod(Invocation.getter(#version), returnValue: '')
          as String);
  @override
  String get buildNumber =>
      (super.noSuchMethod(Invocation.getter(#buildNumber), returnValue: '')
          as String);
  @override
  String toString() => super.toString();
}

/// A class which mocks [AppSettings].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppSettings extends _i1.Mock implements _i4.AppSettings {
  MockAppSettings() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.StreamingSharedPreferences get preferences =>
      (super.noSuchMethod(Invocation.getter(#preferences),
              returnValue: _FakeStreamingSharedPreferences_0())
          as _i2.StreamingSharedPreferences);
  @override
  _i2.Preference<int> get lastKnownVersionCodePrefs =>
      (super.noSuchMethod(Invocation.getter(#lastKnownVersionCodePrefs),
          returnValue: _FakePreference_1<int>()) as _i2.Preference<int>);
  @override
  _i2.Preference<List<_i5.Channel>> get channels =>
      (super.noSuchMethod(Invocation.getter(#channels),
              returnValue: _FakePreference_1<List<_i5.Channel>>())
          as _i2.Preference<List<_i5.Channel>>);
  @override
  int get lastKnownVersionCode =>
      (super.noSuchMethod(Invocation.getter(#lastKnownVersionCode),
          returnValue: 0) as int);
  @override
  set lastKnownVersionCode(int? current) =>
      super.noSuchMethod(Invocation.setter(#lastKnownVersionCode, current),
          returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}
