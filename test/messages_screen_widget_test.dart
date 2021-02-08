// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/api/data_service.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/gis.dart';
import 'package:mobile/model/region.dart';
import 'package:mobile/screens/messages.dart';
import 'package:mobile/app_settings.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'support.dart';

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

  final Channel channelWithoutLocationAndCategories = Channel.empty();

  final Channel channelWithBerlinLocationWithoutCategories = Channel(
    ChannelLocation(
        "Berlin", Coordinate(13.4105300, 52.5243700), Region.empty()),
    Set.of([]),
    Set.of([]),
  );

  setUpAll(
    () async {
      SharedPreferences.setMockInitialValues({});
      streamingSharedPreferences = await StreamingSharedPreferences.instance;
      appSettings = AppSettings(streamingSharedPreferences);
      getIt.registerSingleton(appSettings);
      getIt.registerSingleton(restClient);
      getIt.registerSingleton(DataService());
    },
  );

  tearDownAll(
    () {
      getIt.reset();
    },
  );

  group('Message List for one channel', () {
    setUp(() async {
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

      await createWidgetWrappedInColumn(tester, MessagesScreen());
      await tester.pump();
      await untilCalled(restClient.fetchRawFeed());

      expect(progressIndicatorFinder, findsOneWidget);
      expect(find.text('Message Heading 1'), findsNothing);
      expect(find.text('Message Content 1'), findsNothing);
      expect(find.text('Message Heading 2'), findsNothing);
      expect(find.text('Message Content 2'), findsNothing);
    });

    testWidgets('Message List shows test message 1',
        (WidgetTester tester) async {
      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchRawFeed()).thenAnswer(
        (_) async => [message1],
      );

      await createWidgetWrappedInColumn(tester, MessagesScreen());
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

      await createWidgetWrappedInColumn(tester, MessagesScreen());
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

      await createWidgetWrappedInColumn(tester, MessagesScreen());
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
