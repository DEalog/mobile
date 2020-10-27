// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Mobile App Navigation', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    group('Home Screen', () {
      test('Homescreen setup', () async {
        await driver.waitFor(find.byValueKey("DEalogLogoKey"));
        await driver.waitFor(find.byValueKey("AppBarButtonDehaze"));
      });
    });

    group('Onboarding Tests', () {
      test('Should start with settings at first run', () async {
        await driver.tap(find.byValueKey("AppBarButtonDehaze"));
        await driver.waitFor(find.byValueKey("DEalogLogoKey"));
        await driver.waitFor(find.text("Please subscribe a channel!"));
        await driver.waitFor(find.text("Subscribed Channels"));
        await driver.waitFor(find.byValueKey("add_channel"));
      });

      test('Add device location fire channel', () async {
        await driver.waitForAbsent(find.text("Fire"));

        await driver.tap(find.byValueKey("add_channel"));

        await scrollAndTap("state_FIRE", driver);

        await scrollAndTap("submit_channel", driver);

        await driver.waitFor(find.text("Fire"));
        await driver.waitForAbsent(find.text("Please subscribe a channel!"));
      });

      test('Add custom location weather and env channel', () async {
        await driver.waitForAbsent(find.text("Meteorological"));
        await driver.waitForAbsent(find.text("Environment"));

        await driver.tap(find.byValueKey("add_channel"));

        await driver.tap(find.byValueKey("use_location_toggle"));

        await driver.tap(find.byValueKey("location_input"));
        await driver.enterText("my location");

        await scrollAndTap("state_MET", driver);
        await scrollAndTap("state_ENV", driver);

        await scrollAndTap("submit_channel", driver);

        await driver.waitFor(find.text("Meteorological"));
        await driver.waitFor(find.text("Environment"));
      });

      test('Add another channel removes add channel button', () async {
        await driver.waitForAbsent(find.text("Health"));

        await driver.tap(find.byValueKey("add_channel"));

        await scrollAndTap("state_HEALTH", driver);

        await scrollAndTap("submit_channel", driver);

        await driver.waitFor(find.text("Health"));
        await driver.waitForAbsent(find.byValueKey("add_channel"));
      });

      test('Deleting all channels should show message', () async {
        await driver.waitForAbsent(find.text("Please subscribe a channel!"));
        await driver.tap(find.byValueKey("delete_channel_0"));

        await driver.waitForAbsent(find.text("Please subscribe a channel!"));
        await driver.tap(find.byValueKey("delete_channel_0"));

        await driver.waitForAbsent(find.text("Please subscribe a channel!"));
        await driver.tap(find.byValueKey("delete_channel_0"));

        await driver.waitFor(find.text("Please subscribe a channel!"));
      });
    });
  });
}

Future scrollAndTap(String key, FlutterDriver driver) async {
  var submitChannel = find.byValueKey(key);
  await driver.scrollIntoView(submitChannel);
  await driver.tap(submitChannel);
}
