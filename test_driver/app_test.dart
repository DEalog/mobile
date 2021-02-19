// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Mobile App Navigation', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      final Map<String, String> envVars = Platform.environment;
      final String adbPath =
          envVars['ANDROID_SDK_ROOT'] + '/platform-tools/adb';
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'de.dealog.mobile.pilot',
        'android.permission.ACCESS_COARSE_LOCATION'
      ]);
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'de.dealog.mobile.pilot',
        'android.permission.ACCESS_FINE_LOCATION'
      ]);
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
        await driver.waitFor(
          find.byValueKey("wizardUseLocationIconSolid"),
          timeout: Duration(seconds: 5),
        );
        await driver.tap(find.byValueKey("wizardContinue"));
        await driver.waitForAbsent(
          find.byValueKey("wizardUseLocationIconSolid"),
        );
        await driver.tap(find.byValueKey("wizardContinue"));
        await scrollAndTap("state_FIRE", 'listview_multiselect', driver);
        await driver.tap(find.byValueKey("wizardSave"));
        await driver.waitFor(find.byValueKey('locationView'));
        await driver.waitFor(find.byValueKey('locationViewCurrentLocation'));
      });
    });

    group('Home Screen', () {
      test('Homescreen setup', () async {
        await driver.waitFor(find.byValueKey("DEalogLogoKey"));
        await driver.waitFor(find.byValueKey("AppBarButtonSettings"));
        await driver.waitFor(find.byValueKey("AppBarWizardButton"));
      });
    });

    group('Add Channel on homescreen', () {
      test('Open Wizard for new channel', () async {
        await driver.tap(find.byValueKey("AppBarWizardButton"));
        await driver.waitFor(find.byValueKey("DEalogLogoKey"));
        await driver.waitFor(find.byValueKey("wizardCancel"));
        await driver.waitFor(find.byValueKey("wizardContinue"));
        await driver.waitFor(find.byValueKey("wizardFormOneText"));
        await driver.tap(find.byValueKey("wizardCancel"));
        await driver.waitFor(find.byValueKey("AppBarWizardButton"));
      });
      test('Add custom location without weather and env channel', () async {
        await driver.tap(find.byValueKey("AppBarWizardButton"));

        await driver.tap(find.byValueKey('wizardLocationTextField_toggle'));
        await driver.enterText('Arnsberg');
        await driver.tap(find.byValueKey("wizardContinue"));
        await driver.tap(find.byValueKey("wizardContinue"));

        await scrollAndTap("state_MET", 'listview_multiselect', driver);
        await scrollAndTap("state_ENV", 'listview_multiselect', driver);

        await driver.tap(find.byValueKey("wizardSave"));
        await driver.waitFor(find.byValueKey('locationView'));
        await driver.waitFor(find.text("Arnsberg"));
      });
    });
  });
}

Future scrollAndTap(
    String itemKey, String scrollWidgetKey, FlutterDriver driver) async {
  var itemFinder = find.byValueKey(itemKey);
  var scrollable = find.byValueKey(scrollWidgetKey);
  await driver.scrollUntilVisible(
    scrollable,
    itemFinder,
    dyScroll: -150.0,
  );
  await driver.tap(
    itemFinder,
  );
  await Future.delayed(Duration(milliseconds: 200));
}
