import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// The application under test.
import 'package:mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding Tests Form', () {
    // setUpAll(() async {
    //   app.main();
    // });

    testWidgets('Should start with settings at first run',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(
        Duration(seconds: 5),
      );

      expect(find.byKey(Key('DEalogLogoKey')), findsOneWidget);
      expect(find.byKey(Key('wizardContinue')), findsOneWidget);
      expect(find.byKey(Key('wizardFormOneText')), findsOneWidget);
      expect(find.byKey(Key('wizardCancel')), findsNothing);
    });

    testWidgets('Add device location all channels but fire channel',
        (WidgetTester tester) async {
      // app.main();
      await tester.pumpAndSettle(
        Duration(seconds: 5),
      );

      await tester.tap(find.byKey(Key("wizardUseLocationButton")));

      await tester.pumpAndSettle(
        Duration(seconds: 1),
      );
      expect(find.byKey(Key("wizardUseLocationIconSolid")), findsOneWidget);

      await tester.tap(find.byKey(Key("wizardContinue")));
      await tester.pumpAndSettle(
        Duration(seconds: 1),
      );
      expect(find.byKey(Key("RegionHierarchyMultiSelect")), findsOneWidget);

      await tester.tap(find.byKey(Key("wizardContinue")));
      await tester.pumpAndSettle(
        Duration(seconds: 1),
      );
      await scrollAndTapDy50("state_FIRE", 'listview_multiselect', tester);

      await tester.pumpAndSettle(
        Duration(seconds: 1),
      );
      await tester.tap(find.byKey(Key("wizardSave")));
      await tester.pumpAndSettle(
        Duration(seconds: 1),
      );
      expect(find.byKey(Key("locationView")), findsOneWidget);
      expect(find.byKey(Key("locationViewCurrentLocation")), findsOneWidget);
    });
  });
}

Future scrollAndTapDx50(
    String itemKey, String scrollWidgetKey, WidgetTester tester) async {
  scrollAndTap(itemKey, scrollWidgetKey, tester, const Offset(-50.0, 0.0));
}

Future scrollAndTapDy50(
    String itemKey, String scrollWidgetKey, WidgetTester tester) async {
  scrollAndTap(itemKey, scrollWidgetKey, tester, const Offset(0.0, -50.0));
}

Future scrollAndTap(String itemKey, String scrollWidgetKey, WidgetTester tester,
    Offset offset) async {
  var itemFinder = find.byKey(Key(itemKey));
  var scrollable = find.byKey(Key(scrollWidgetKey));

  await tester.dragUntilVisible(
    itemFinder,
    scrollable,
    offset,
  );

  await tester.tap(
    itemFinder,
  );
  await Future.delayed(Duration(milliseconds: 200));
}
