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
    final homeTextFinder = find.text('Home');
    final settingsTextFinder = find.text('Settings');
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
    test('Switch between home screen and setting screen', () async {
      // Verify home screen
      expect(await driver.getText(settingsTextFinder), "Settings");

      // Tap the settings button
      await driver.tap(settingsTextFinder);

      // Verify home screen
      expect(await driver.getText(homeTextFinder), "Home");
    });
  });
}
