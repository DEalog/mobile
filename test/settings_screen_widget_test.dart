// Mock class
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/api/data_service.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/screens/settings.dart';
import 'package:mobile/app_settings.dart';
import 'package:mobile/version.dart';
import 'package:mockito/mockito.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'support.dart';

class MockRestClient extends Mock implements RestClient {}

class MockVersion extends Mock implements Version {}

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

void main() {
  RestClient restClient = MockRestClient();
  Version version = MockVersion();
  AppSettings appSettings;
  StreamingSharedPreferences streamingSharedPreferences;

  var testMessageListEmpty = {
    {
      "content": [],
      "meta": {
        "number": 0,
        "size": 0,
        "totalElements": 1,
        "totalPages": 1,
      }
    }
  };

  final Channel channelWithoutLocationAndCategories = Channel(
    ChannelLocation.empty(),
    Set.of([]),
    List.empty(),
    Set.of([]),
  );

  setUpAll(
    () async {
      SharedPreferences.setMockInitialValues({});
      streamingSharedPreferences = await StreamingSharedPreferences.instance;
      appSettings = AppSettings(streamingSharedPreferences);
      getIt.registerSingleton(appSettings);
      getIt.registerSingleton(version);
      getIt.registerSingleton(restClient);
      getIt.registerSingleton(DataService());
    },
  );

  tearDownAll(
    () {
      getIt.reset();
    },
  );

  group('Nav bar', () {
    setUp(() async {
      streamingSharedPreferences.setStringList(
        AppSettings.LOCATIONS_KEY,
        [jsonEncode(channelWithoutLocationAndCategories.toJson())],
      );
    });

    testWidgets(
      "Show DEalog logo and Back Button",
      (WidgetTester tester) async {
        // Set test messages to feed service
        // mock raw feed
        when(
          restClient.fetchMessages('1235', 1, 1),
        ).thenAnswer(
          (_) => Future.value(
            jsonEncode(
              testMessageListEmpty,
            ),
          ),
        );

        when(version.state).thenReturn(
          VersionState.UNCHANGED,
        );
        when(version.versionCode).thenReturn(
          0,
        );
        when(version.version).thenReturn(
          '1.0.0',
        );

        await createWidget(tester, SettingsScreen());
        await tester.pump();

        // Verify settings screen
        expect(find.byKey(Key('DEalogLogoKey')), findsOneWidget);
        expect(find.byKey(Key('AppBarButtonSettings')), findsNothing);
        expect(find.byKey(Key('AppBarButtonBack')), findsOneWidget);
      },
    );
    tearDown(() async {
      expect(await streamingSharedPreferences.clear(), isTrue);
    });
  });
}
