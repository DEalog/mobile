// Mocks generated by Mockito 5.0.2 from annotations
// in mobile/test/data_service_unit_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mobile/api/rest_client.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [RestClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockRestClient extends _i1.Mock implements _i2.RestClient {
  MockRestClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get authority =>
      (super.noSuchMethod(Invocation.getter(#authority), returnValue: '')
          as String);
  @override
  String get encoding =>
      (super.noSuchMethod(Invocation.getter(#encoding), returnValue: '')
          as String);
  @override
  List<String> get dummyMessages =>
      (super.noSuchMethod(Invocation.getter(#dummyMessages),
          returnValue: <String>[]) as List<String>);
  @override
  _i3.Future<String> getRegions(String? regionName) =>
      (super.noSuchMethod(Invocation.method(#getRegions, [regionName]),
          returnValue: Future.value('')) as _i3.Future<String>);
  @override
  _i3.Future<String> getRegionsByType(
          String? regionName, List<String>? regionLevels) =>
      (super.noSuchMethod(
          Invocation.method(#getRegionsByType, [regionName, regionLevels]),
          returnValue: Future.value('')) as _i3.Future<String>);
  @override
  _i3.Future<String> getRegionHierarchyById(String? id) =>
      (super.noSuchMethod(Invocation.method(#getRegionHierarchyById, [id]),
          returnValue: Future.value('')) as _i3.Future<String>);
  @override
  _i3.Future<String> getRegionHierarchyByCoordinates(
          double? lat, double? long) =>
      (super.noSuchMethod(
          Invocation.method(#getRegionHierarchyByCoordinates, [lat, long]),
          returnValue: Future.value('')) as _i3.Future<String>);
  @override
  _i3.Future<String> fetchMessages(String? ars, int? size, int? page) =>
      (super.noSuchMethod(Invocation.method(#fetchMessages, [ars, size, page]),
          returnValue: Future.value('')) as _i3.Future<String>);
}