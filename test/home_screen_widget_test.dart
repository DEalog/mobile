// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/feed_service.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/api/serializer.dart';
import 'package:mobile/screens/home.dart';
import 'package:mockito/mockito.dart';

// Mock class
class MockRestClient extends Mock implements RestClient {}

void main() {
  RestClient restClient;
  Serializer serializer;
  FeedService feedService;
  String message1 =
      '{ "identifier": "Message Heading 1", "description": "Message Content 1" }';
  String message2 =
      '{ "identifier": "Message Heading 2", "description": "Message Content 2" }';

  group('Bottom button bar', () {
    testWidgets('Home screen show Home text', (WidgetTester tester) async {
      //
      await tester.pumpWidget(HomeScreen());

      // Verify home screen
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsNothing);
    });
  });

  group('Message List', () {
    setUp(() {
      restClient = MockRestClient();
      serializer = Serializer();
      feedService = FeedService(restClient, serializer);
    });

    testWidgets('Message List shows test message 1',
        (WidgetTester tester) async {
      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchRawFeed()).thenAnswer(
        (_) => Future.value(
          Future.value(
            [message1],
          ),
        ),
      );

      await tester.pumpWidget(HomeScreen());

      expect(find.text('Message Heading 1'), findsOneWidget);
      expect(find.text('Message Content 1'), findsOneWidget);
    });
  });
}
