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

    test('Should start with settings at first run', () async {
      await driver.waitFor(find.text("Please subscribe a channel!"));
      await driver.waitFor(find.text("Subscribed Channels"));
      await driver.waitFor(find.byValueKey("add_channel"));
    });

    test('Should show navigation', () async {
      await driver.waitFor(find.byValueKey("navigate_home"));
      await driver.waitFor(find.byValueKey("navigate_settings"));
    });

    test('Add device location fire channel', () async {
      await driver.tap(find.byValueKey("navigate_settings"));

      await driver.waitForAbsent(find.text("Fire"));

      await driver.tap(find.byValueKey("add_channel"));

      await driver.tap(find.byValueKey("state_FIRE"));

      var submitChannel = find.byValueKey("submit_channel");
      await driver.scrollIntoView(submitChannel);
      await driver.tap(submitChannel);

      await driver.waitFor(find.text("Fire"));
      await driver.waitForAbsent(find.text("Please subscribe a channel!"));
    });

    test('Add custom location weather and env channel', () async {
      await driver.tap(find.byValueKey("navigate_settings"));

      await driver.waitForAbsent(find.text("Meteorological"));
      await driver.waitForAbsent(find.text("Environment"));

      await driver.tap(find.byValueKey("add_channel"));

      await driver.tap(find.byValueKey("use_location_toggle"));

      await driver.tap(find.byValueKey("location_input"));
      await driver.enterText("my location");

      await driver.tap(find.byValueKey("state_MET"));
      await driver.tap(find.byValueKey("state_ENV"));

      var submitChannel = find.byValueKey("submit_channel");
      await driver.scrollIntoView(submitChannel);
      await driver.tap(submitChannel);

      await driver.waitFor(find.text("Meteorological"));
      await driver.waitFor(find.text("Environment"));
    });

    test('Add another channel removes add channel button', () async {
      print("### go to settingsl");
      await driver.tap(find.byValueKey("navigate_settings"));

      print("### check non existent Health text");
      await driver.waitForAbsent(find.text("Health"));

      print("### add channel");
      await driver.tap(find.byValueKey("add_channel"));

      print("### tap state_Infra");
      await driver.tap(find.byValueKey("state_HEALTH"));

      print("### submit channel");
      var submitChannel = find.byValueKey("submit_channel");
      await driver.scrollIntoView(submitChannel);
      await driver.tap(submitChannel);

      print("### check existent Health text");
      await driver.waitFor(find.text("Health"));
      await driver.waitForAbsent(find.byValueKey("add_channel"));
    });

    test('Deleting all channels should show message', () async {
      await driver.tap(find.byValueKey("navigate_settings"));

      await driver.waitForAbsent(find.text("Please subscribe a channel!"));
      await driver.tap(find.byValueKey("delete_channel_0"));

      await driver.waitForAbsent(find.text("Please subscribe a channel!"));
      await driver.tap(find.byValueKey("delete_channel_0"));

      await driver.waitForAbsent(find.text("Please subscribe a channel!"));
      await driver.tap(find.byValueKey("delete_channel_0"));

      await driver.waitFor(find.text("Please subscribe a channel!"));
    });
  });
}
