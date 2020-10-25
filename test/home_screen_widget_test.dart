// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/api/feed_service.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/api/serializer.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/gis.dart';
import 'package:mobile/screens/home.dart';
import 'package:mobile/settings.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'test_utils.dart';

// Mock class
class MockRestClient extends Mock implements RestClient {}

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

void main() {
  RestClient restClient = MockRestClient();
  AppSettings appSettings;
  StreamingSharedPreferences streamingSharedPreferences;

  final String message1 =
      '{ "identifier": "Message Heading 1", "description": "Message Content 1" }';
  final String message2 =
      '{ "identifier": "Message Heading 2", "description": "Message Content 2" }';
  final messageKey = Key('Message');

  final Channel channelWithoutLocationAndCategories = Channel(
    null,
    Set.of([]),
    Set.of([]),
  );

  final Channel channelWithBerlinLocationWithoutCategories = Channel(
    Location(
        "Berlin", Coordinate(13.4105300, 52.5243700), Map.fromIterable([])),
    Set.of([]),
    Set.of([]),
  );

  setUpAll(
    () async {
      SharedPreferences.setMockInitialValues({});
      streamingSharedPreferences = await StreamingSharedPreferences.instance;
      appSettings = AppSettings(streamingSharedPreferences);
      getIt.registerSingleton(appSettings);
      getIt.registerSingleton(Serializer());
      getIt.registerSingleton(restClient);
      getIt.registerSingleton(FeedService());
    },
  );

  tearDownAll(
    () {
      getIt.reset();
    },
  );

  group('Bottom button bar', () {
    setUp(() {
      streamingSharedPreferences.setStringList(
        AppSettings.LOCATIONS_KEY,
        [jsonEncode(channelWithoutLocationAndCategories.toJson())],
      );
    });

    testWidgets('Home screen show Home text', (WidgetTester tester) async {
      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchRawFeed()).thenAnswer(
        (_) => Future.value([]),
      );

      await createWidget(tester, HomeScreen());

      // Verify home screen
      expect(find.text('Home'), findsNothing);
      expect(find.text('Settings'), findsNothing);
    });

    tearDown(() async {
      expect(await streamingSharedPreferences.clear(), isTrue);
    });
  });

  group('Message List for one channel', () {
    setUp(() {
      streamingSharedPreferences.setStringList(
        AppSettings.LOCATIONS_KEY,
        [jsonEncode(channelWithoutLocationAndCategories.toJson())],
      );
    });

    testWidgets('restClient returns no message', (WidgetTester tester) async {
      final progressIndicatorFinder =
          find.byKey(Key("CircularProgressIndicator"));

      // Set test messages to feed service
      // mock raw feed
      when(
        restClient.fetchRawFeed(),
      ).thenAnswer(
        (_) async => [],
      );

      await createWidget(tester, HomeScreen());
      await tester.pump();

      await tester.runAsync(() async {
        tester.ensureVisible(progressIndicatorFinder);
        expect(progressIndicatorFinder, findsOneWidget);
        expect(find.text('Message Heading 1'), findsNothing);
        expect(find.text('Message Content 1'), findsNothing);
        expect(find.text('Message Heading 2'), findsNothing);
        expect(find.text('Message Content 2'), findsNothing);
      });
    });

    testWidgets('Message List shows test message 1',
        (WidgetTester tester) async {
      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchRawFeed()).thenAnswer(
        (_) async => [message1],
      );

      await createWidget(tester, HomeScreen());
      await untilCalled(restClient.fetchRawFeed());
      await tester.pumpAndSettle();

      expect(find.byKey(messageKey), findsOneWidget);
      expect(find.text('Message Heading 1'), findsOneWidget);
      expect(find.text('Message Content 1'), findsOneWidget);
      expect(find.text('Message Heading 2'), findsNothing);
      expect(find.text('Message Content 2'), findsNothing);
    });

    testWidgets('Message List shows test message 1 and test message 2',
        (WidgetTester tester) async {
      final finders = [
        find.text('Message Heading 1'),
        find.text('Message Content 1'),
        find.text('Message Heading 2'),
        find.text('Message Content 2'),
      ];

      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchRawFeed()).thenAnswer(
        (_) async => [message1, message2],
      );

      await createWidget(tester, HomeScreen());
      await untilCalled(restClient.fetchRawFeed());
      await tester.pumpAndSettle();

      finders.forEach((finder) async {
        expect(finder, findsOneWidget);
      });
    });

    tearDown(() async {
      expect(await streamingSharedPreferences.clear(), isTrue);
    });
  });

  group('Message Lists for two channels', () {
    setUp(() {
      streamingSharedPreferences.setStringList(
        AppSettings.LOCATIONS_KEY,
        [
          jsonEncode(channelWithoutLocationAndCategories.toJson()),
          jsonEncode(channelWithBerlinLocationWithoutCategories.toJson()),
        ],
      );
    });

    testWidgets(
        'Message List shows test message 1 and test message 2 for two channels',
        (WidgetTester tester) async {
      final finders = [
        find.text('Message Heading 1'),
        find.text('Message Content 1'),
        find.text('Message Heading 2'),
        find.text('Message Content 2'),
      ];

      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchRawFeed()).thenAnswer(
        (_) async => [message1, message2],
      );

      await createWidget(tester, HomeScreen());
      await untilCalled(restClient.fetchRawFeed());
      await tester.pumpAndSettle();

      finders.forEach((finder) async {
        expect(finder, findsNWidgets(2));
      });
    });

    tearDown(() async {
      expect(await streamingSharedPreferences.clear(), isTrue);
    });
  });
}
