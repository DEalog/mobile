// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
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
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'support.dart';
import 'messages_screen_widget_test.mocks.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

@GenerateMocks([RestClient])
void main() {
  RestClient restClient = MockRestClient();
  AppSettings appSettings;
  late StreamingSharedPreferences streamingSharedPreferences;

  var testMessageListEmpty = {
    "content": [],
    "meta": {
      "size": 10,
      "number": 0,
      "totalElements": 0,
      "totalPages": 0,
    }
  };
  var testMessageListWith1Message = {
    "content": [
      {
        "ars": "059580004004",
        "category": "Other",
        "description": "Message Content 1",
        "headline": "Message Heading 1",
        "identifier": "1f3f84e6-ae09-405b-968e-8a231a5abb70",
        "organization": "DEalog Team",
        "publishedAt": "2020-11-25T20:34:38.098+0000"
      },
    ],
    "meta": {
      "number": 0,
      "size": 1,
      "totalElements": 1,
      "totalPages": 1,
    }
  };

  var testMessageListWith2Messages = {
    "content": [
      {
        "ars": "059580004004",
        "category": "Other",
        "description": "Message Content 1",
        "headline": "Message Heading 1",
        "identifier": "1f3f84e6-ae09-405b-968e-8a231a5abb70",
        "organization": "DEalog Team",
        "publishedAt": "2020-11-25T20:34:38.098+0000"
      },
      {
        "ars": "059580004004",
        "category": "Other",
        "description": "Message Content 2",
        "headline": "Message Heading 2",
        "identifier": "90325ca5-5c5e-4cb3-987d-af830e13f707",
        "organization": "DEalog Team",
        "publishedAt": "2020-10-17T10:45:06.670+0000"
      },
    ],
    "meta": {
      "number": 0,
      "size": 2,
      "totalElements": 1,
      "totalPages": 1,
    }
  };

  var testMessageList2With2Messages = {
    "content": [
      {
        "ars": "059580004004",
        "category": "Other",
        "description": "Message Content 3",
        "headline": "Message Heading 3",
        "identifier": "1f3f84e6-ae09-405b-968e-8a231a5abb70",
        "organization": "DEalog Team",
        "publishedAt": "2020-11-25T20:34:38.098+0000"
      },
      {
        "ars": "059580004004",
        "category": "Other",
        "description": "Message Content 4",
        "headline": "Message Heading 4",
        "identifier": "90325ca5-5c5e-4cb3-987d-af830e13f707",
        "organization": "DEalog Team",
        "publishedAt": "2020-10-17T10:45:06.670+0000"
      },
    ],
    "meta": {
      "number": 0,
      "size": 2,
      "totalElements": 1,
      "totalPages": 1,
    }
  };

  final pageSize = 10;

  final Channel channelWithoutLocationAndCategories = Channel(
    ChannelLocation(
      'Arnsberg',
      Coordinate.invalid(),
      Region(
        '059580004004',
        'Arnsberg',
        RegionLevel.MUNICIPALITY,
      ),
    ),
    Set.of([
      RegionLevel.COUNTRY,
      RegionLevel.DISTRICT,
      RegionLevel.MUNICIPALITY,
    ]),
    [],
    Set.of([
      ChannelCategory.CBRNE,
      ChannelCategory.FIRE,
    ]),
  );

  final Channel channelWithBerlinLocationWithoutCategories = Channel(
    ChannelLocation(
      "Berlin",
      Coordinate(13.4105300, 52.5243700),
      Region.empty(),
    ),
    Set.of([
      RegionLevel.COUNTRY,
      RegionLevel.DISTRICT,
      RegionLevel.MUNICIPALITY,
    ]),
    [
      Region(
        '001',
        'Berlin',
        RegionLevel.MUNICIPALITY,
      ),
    ],
    Set.of([
      ChannelCategory.CBRNE,
      ChannelCategory.FIRE,
    ]),
  );

  setUpAll(
    () async {
      SharedPreferences.setMockInitialValues({});
      streamingSharedPreferences = await StreamingSharedPreferences.instance;
      appSettings = AppSettings(streamingSharedPreferences);
      getIt.registerSingleton(appSettings);
      getIt.registerSingleton(restClient);
      getIt.registerSingleton(DataService());
      await EasyLocalization.ensureInitialized();
    },
  );

  tearDownAll(
    () {
      getIt.reset();
    },
  );

  group('Message List for one channel', () {
    setUp(() async {
      expect(
        await streamingSharedPreferences.setStringList(
          AppSettings.LOCATIONS_KEY,
          [jsonEncode(channelWithoutLocationAndCategories.toJson())],
        ),
        true,
      );
    });

    testWidgets('restClient returns no message', (WidgetTester tester) async {
      final noMessagesReturned = find.byKey(Key("NoFeedMessagesAvailable"));

      // Set test messages to feed service
      // mock raw feed
      when(
        restClient.fetchMessages("059580004004", pageSize, 0),
      ).thenAnswer(
        (_) => Future.value(
          jsonEncode(
            testMessageListEmpty,
          ),
        ),
      );

      await createWidgetWrappedInColumn(tester, MessagesScreen());
      await tester.pumpAndSettle();
      await untilCalled(restClient.fetchMessages("059580004004", pageSize, 0));

      expect(noMessagesReturned, findsOneWidget);
      expect(find.text('Message Heading 1'), findsNothing);
      expect(find.text('Message Content 1'), findsNothing);
      expect(find.text('Message Heading 2'), findsNothing);
      expect(find.text('Message Content 2'), findsNothing);
    });

    testWidgets('Message List shows test message 1',
        (WidgetTester tester) async {
      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchMessages("059580004004", pageSize, 0)).thenAnswer(
        (_) => Future.value(
          jsonEncode(
            testMessageListWith1Message,
          ),
        ),
      );

      await createWidgetWrappedInColumn(tester, MessagesScreen());
      await tester.pumpAndSettle();
      await untilCalled(restClient.fetchMessages('059580004004', pageSize, 0));

      expect(find.byKey(Key('Message_0_0')), findsOneWidget);
      expect(find.text('Message Heading 1'), findsOneWidget);
      expect(find.text('Message Content 1'), findsOneWidget);
      expect(find.text('Message Heading 2'), findsNothing);
      expect(find.text('Message Content 2'), findsNothing);
    });

    testWidgets('Message List shows test message 1 and test message 2',
        (WidgetTester tester) async {
      final findersMessage1 = [
        find.byKey(Key('Message_0_0')),
        find.text('Message Heading 1'),
        find.text('Message Content 1'),
      ];

      final findersMessage2 = [
        find.byKey(Key('Message_0_1')),
        find.text('Message Heading 2'),
        find.text('Message Content 2'),
      ];

      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchMessages('059580004004', pageSize, 0)).thenAnswer(
        (_) => Future.value(
          jsonEncode(
            testMessageListWith2Messages,
          ),
        ),
      );

      await createWidgetWrappedInColumn(tester, MessagesScreen());
      await tester.pumpAndSettle();
      await untilCalled(restClient.fetchMessages('059580004004', pageSize, 0));

      findersMessage1.forEach((finder) async {
        expect(finder, findsOneWidget);
      });

      await tester.dragUntilVisible(
        find.byKey(Key('Message_0_1')),
        find.byKey(Key('PageListViewMessages_0')),
        const Offset(-50.0, 0.0),
      );

      findersMessage2.forEach((finder) async {
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
      final findersMessage01 = [
        find.byKey(Key('Message_0_0')),
        find.text('Message Heading 1'),
        find.text('Message Content 1'),
      ];

      final findersMessage02 = [
        find.byKey(Key('Message_0_1')),
        find.text('Message Heading 2'),
        find.text('Message Content 2'),
      ];

      final findersMessage11 = [
        find.byKey(Key('Message_1_0')),
        find.text('Message Heading 3'),
        find.text('Message Content 3'),
      ];

      final findersMessage12 = [
        find.byKey(Key('Message_1_1')),
        find.text('Message Heading 4'),
        find.text('Message Content 4'),
      ];

      // Set test messages to feed service
      // mock raw feed
      when(restClient.fetchMessages('001', pageSize, 0)).thenAnswer(
        (_) => Future.value(
          jsonEncode(
            testMessageList2With2Messages,
          ),
        ),
      );
      when(restClient.fetchMessages('059580004004', pageSize, 0)).thenAnswer(
        (_) => Future.value(
          jsonEncode(
            testMessageListWith2Messages,
          ),
        ),
      );

      await createWidgetWrappedInColumn(tester, MessagesScreen());
      await tester.pumpAndSettle();

      // Check first channel
      await untilCalled(restClient.fetchMessages('059580004004', pageSize, 0));

      findersMessage01.forEach((finder) async {
        expect(finder, findsOneWidget);
      });

      await tester.dragUntilVisible(
        find.byKey(Key('Message_0_1')),
        find.byKey(Key('PageListViewMessages_0')),
        const Offset(-50.0, 0.0),
      );

      findersMessage02.forEach((finder) async {
        expect(finder, findsOneWidget);
      });

      // Check second channel
      await untilCalled(restClient.fetchMessages('001', pageSize, 0));

      findersMessage11.forEach((finder) async {
        expect(finder, findsOneWidget);
      });

      await tester.dragUntilVisible(
        find.byKey(Key('Message_1_1')),
        find.byKey(Key('PageListViewMessages_1')),
        const Offset(-50.0, 0.0),
      );

      findersMessage12.forEach((finder) async {
        expect(finder, findsOneWidget);
      });
    });

    tearDown(() async {
      expect(await streamingSharedPreferences.clear(), isTrue);
    });
  });
}
