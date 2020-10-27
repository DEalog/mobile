// Mock class
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/api/feed_service.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/api/serializer.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/screens/settings.dart';
import 'package:mobile/settings.dart';
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

  final Channel channelWithoutLocationAndCategories = Channel(
    Location(null, 0.0, 0.0),
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
        when(restClient.fetchRawFeed()).thenAnswer(
          (_) => Future.value([]),
        );

        when(version.state).thenReturn(
          VersionState.UNCHANGED,
        );

        await createWidget(tester, SettingsScreen());
        await tester.pump();

        // Verify settings screen
        expect(find.byKey(Key('DEalogLogoKey')), findsOneWidget);
        expect(find.byKey(Key('AppBarButtonDehaze')), findsNothing);
        expect(find.byKey(Key('AppBarButtonBack')), findsOneWidget);
      },
    );
    tearDown(() async {
      expect(await streamingSharedPreferences.clear(), isTrue);
    });
  });
}
