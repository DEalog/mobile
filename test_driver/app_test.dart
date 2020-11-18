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

    group('Onboarding Tests Form', () {
      test('Should start with settings at first run', () async {
        await driver.waitFor(find.byValueKey("DEalogLogoKey"));
        await driver.waitForAbsent(find.byValueKey("wizardCancel"));
        await driver.waitFor(find.byValueKey("wizardContinue"));
        await driver.waitFor(find.byValueKey("wizardFormOneText"));
      });

      test('Add device location all channels but fire channel', () async {
        await driver.tap(find.byValueKey("wizardUseLocationButton"));
        await driver.tap(find.byValueKey("wizardContinue"));
        await driver.tap(find.byValueKey("wizardContinue"));
        await scrollAndTap("state_FIRE", driver);
        await driver.tap(find.byValueKey("wizardSave"));
        await driver.waitFor(find.byValueKey('locationView'));
        await driver.waitFor(find.byValueKey('locationViewCurrentLocation'));
      });

      test('Add custom location without weather and env channel', () async {
        await driver.tap(find.byValueKey("AppBarWizardButton"));

        await driver.tap(find.byValueKey('wizardLocationTextField'));
        await driver.enterText('Arnsberg');
        await driver.tap(find.byValueKey("wizardContinue"));
        await driver.tap(find.byValueKey("wizardContinue"));

        await scrollAndTap("state_MET", driver);
        await scrollAndTap("state_ENV", driver);

        await driver.tap(find.byValueKey("wizardSave"));
        await driver.waitFor(find.byValueKey('locationView'));
        await driver.waitFor(find.text("Arnsberg"));
      });
    });

    group('Home Screen', () {
      test('Homescreen setup', () async {
        await driver.waitFor(find.byValueKey("DEalogLogoKey"));
        await driver.waitFor(find.byValueKey("AppBarButtonSettings"));
        await driver.waitFor(find.byValueKey("AppBarWizardButton"));
      });

      test('Open Wizard for new channel', () async {
        await driver.tap(find.byValueKey("AppBarWizardButton"));
        await driver.waitFor(find.byValueKey("DEalogLogoKey"));
        await driver.waitFor(find.byValueKey("wizardCancel"));
        await driver.waitFor(find.byValueKey("wizardContinue"));
        await driver.waitFor(find.byValueKey("wizardFormOneText"));
      });
    });
  });
}

Future scrollAndTap(String key, FlutterDriver driver) async {
  var finder = find.byValueKey(key);
  await driver.scrollIntoView(finder);
  await driver.tap(finder);
}
