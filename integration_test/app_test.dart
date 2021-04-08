import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:integration_test/integration_test.dart';

// The application under test.
import 'package:mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding Tests Form', () {
    testWidgets('Should start with settings at first run',
        (WidgetTester tester) async { 
      await app.main();

      /*
        Should start with settings at first run
       */
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byKey(Key('DEalogLogoKey')), findsOneWidget);
      expect(find.byKey(Key('wizardContinue')), findsOneWidget);
      expect(find.byKey(Key('wizardFormOneText')), findsOneWidget);
      expect(find.byKey(Key('wizardCancel')), findsNothing);

      /* 
        Add device location all channels but fire channel 
      */
      await tester.tap(find.byKey(Key("wizardUseLocationButton")));

      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key("wizardUseLocationIconSolid")), findsOneWidget);

      await tester.tap(find.byKey(Key("wizardContinue")));
      await tester.pump(Duration(seconds: 2));
      expect(find.byKey(Key("RegionHierarchyMultiSelect")), findsOneWidget);

      await tester.tap(find.byKey(Key("wizardContinue")));
      await tester.pump(Duration(seconds: 2));
      await scrollAndTapDy50("state_FIRE", 'listview_multiselect', tester);

      await tester.tap(find.byKey(Key("wizardSave")));
      await tester.pump(Duration(seconds: 2));
      expect(find.byKey(Key("locationView")), findsOneWidget);
      expect(find.byKey(Key("locationViewCurrentLocation")), findsOneWidget);

      /* 
        Homescreen setup 
      */
      expect(find.byKey(Key("DEalogLogoKey")), findsOneWidget);
      expect(find.byKey(Key("AppBarButtonSettings")), findsOneWidget);
      expect(find.byKey(Key("AppBarWizardButton")), findsOneWidget);

      /*
        Open Wizard for new channel
       */
      await tester.tap(find.byKey(Key("AppBarWizardButton")));
      await tester.pump(Duration(seconds: 2));

      expect(find.byKey(Key("DEalogLogoKey")), findsOneWidget);
      expect(find.byKey(Key("wizardCancel")), findsOneWidget);
      expect(find.byKey(Key("wizardContinue")), findsOneWidget);
      expect(find.byKey(Key("wizardFormOneText")), findsOneWidget);

      await tester.tap(find.byKey(Key("wizardCancel")));
      await tester.pump(Duration(seconds: 2));
      expect(find.byKey(Key("AppBarWizardButton")), findsOneWidget);

      /*
        Add custom location without weather and env channel
       */
      await tester.tap(find.byKey(Key("AppBarWizardButton")));
      await tester.pump(Duration(seconds: 2));

      await tester.tap(find.byKey(Key("wizardLocationTextField_toggle")));
      await tester.pump(Duration(seconds: 2));

      await tester.enterText(
        find.byKey(Key("wizardLocationTextField_toggle")),
        'Arnsberg',
      );
      await tester.pump();
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(
        find.descendant(
          of: find.byKey(Key('WizardLocationTextFieldSuggestionTile')),
          matching: find.text("Arnsberg"),
        ),
      );

      await tester.pump(Duration(seconds: 2));
      expect(
        find.byKey(Key("WizardLocationTextFieldSuggestionTile")),
        findsNothing,
      );

      await tester.tap(find.byKey(Key("wizardContinue")));
      await tester.pump(Duration(seconds: 2));
      expect(find.byKey(Key("RegionHierarchyMultiSelect")), findsOneWidget);

      await tester.tap(find.byKey(Key("wizardContinue")));
      await tester.pump(Duration(seconds: 2));
      await scrollAndTapDy50("state_MET", 'listview_multiselect', tester);
      await scrollAndTapDy50("state_ENV", 'listview_multiselect', tester);

      await tester.tap(find.byKey(Key("wizardSave")));
      await tester.pump(Duration(seconds: 2));
      expect(find.byKey(Key("locationView")), findsNWidgets(2));
      expect(find.byKey(Key("locationViewCurrentLocation")), findsOneWidget);
      expect(find.text('Arnsberg'), findsOneWidget);
    });
  });
}

Future scrollAndTapDx50(
    String itemKey, String scrollWidgetKey, WidgetTester tester) async {
  await scrollAndTap(
      itemKey, scrollWidgetKey, tester, const Offset(-50.0, 0.0));
}

Future scrollAndTapDy50(
    String itemKey, String scrollWidgetKey, WidgetTester tester) async {
  await scrollAndTap(
      itemKey, scrollWidgetKey, tester, const Offset(0.0, -50.0));
}

Future scrollAndTap(String itemKey, String scrollWidgetKey, WidgetTester tester,
    Offset offset) async {
  var itemFinder = find.byKey(Key(itemKey));
  var scrollable = find.byKey(Key(scrollWidgetKey));

  await tester.dragUntilVisible(
    itemFinder,
    scrollable,
    offset,
    // duration: Duration(milliseconds: 500),
  );

  await tester.tap(
    itemFinder,
  );

  await tester.pump();
}
