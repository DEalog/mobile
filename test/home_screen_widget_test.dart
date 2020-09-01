// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/feed_service.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/api/serializer.dart';
import 'package:mobile/screens/home.dart';
import 'package:mockito/mockito.dart';

import 'test_utils.dart';

// Mock class
class MockRestClient extends Mock implements RestClient {}

void main() {
  RestClient restClient;
  Serializer serializer;
  FeedService feedService = FeedService();
  final String message1 =
      '{ "identifier": "Message Heading 1", "description": "Message Content 1" }';
  final String message2 =
      '{ "identifier": "Message Heading 2", "description": "Message Content 2" }';
  final messageKey = Key('Message');

  group('Bottom button bar', () {
    setUp(() {
      restClient = MockRestClient();
      serializer = Serializer();
      feedService.setRestClient(restClient);
      feedService.setSerializer(serializer);
    });

    testWidgets('Home screen show Home text', (WidgetTester tester) async {
      //
      await createWidget(tester, HomeScreen());

      // Verify home screen
      expect(find.text('Home'), findsNothing);
      expect(find.text('Settings'), findsNothing);
    });
  });

  group('Message List', () {
    setUp(() {
      restClient = MockRestClient();
      serializer = Serializer();
      feedService.setRestClient(restClient);
      feedService.setSerializer(serializer);
    });

    tearDown(() {
      restClient = null;
      serializer = null;
    });

    testWidgets('restClient returns no message', (WidgetTester tester) async {
      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchRawFeed()).thenAnswer(
        (_) => Future.value([]),
      );

      await createWidget(tester, HomeScreen());
      await untilCalled(restClient.fetchRawFeed());
      expect(find.byKey(Key("CircularProgressIndicator")), findsOneWidget);
      expect(find.text('Message Heading 1'), findsNothing);
      expect(find.text('Message Content 1'), findsNothing);
    });

    testWidgets('Message List shows test message 1',
        (WidgetTester tester) async {
      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchRawFeed()).thenAnswer(
        (_) => Future.value(
          [message1],
        ),
      );

      await createWidget(tester, HomeScreen());
      await untilCalled(restClient.fetchRawFeed());
      await tester.pump();

      expect(find.byKey(messageKey), findsOneWidget);
      expect(find.text('Message Heading 1'), findsOneWidget);
      expect(find.text('Message Content 1'), findsOneWidget);
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
        (_) => Future.value(
          [message1, message2],
        ),
      );

      await createWidget(tester, HomeScreen());
      await untilCalled(restClient.fetchRawFeed());
      await tester.pumpAndSettle();

      finders.forEach((finder) async {
        await tester.ensureVisible(finder);
        expect(finder, findsOneWidget);
      });
    });
  });
}
