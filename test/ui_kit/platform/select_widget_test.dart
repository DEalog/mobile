import 'package:fimber/fimber_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/ui_kit/platform/select.dart';

enum Example { FOO, BAR }

void main() {
  Widget build(Widget widget, TargetPlatform targetPlatform) {
    if (targetPlatform == TargetPlatform.android) {
      return MaterialApp(home: Scaffold(body: widget));
    } else if (targetPlatform == TargetPlatform.iOS) {
      return CupertinoApp(home: widget);
    } else {
      throw ArgumentError("cannot start app for target $targetPlatform");
    }
  }

  testWidgets('Shows multiselect on Android', (WidgetTester tester) async {
    var currentValue;
    final onChanged = (value) {
      Fimber.i("onChanged: $value");
      currentValue = value;
    };
    final elementName = (Example e) => describeEnum(e).toLowerCase();
    var widget = MultiSelect(
      elements: Example.values,
      selected: [Example.FOO],
      elementName: elementName,
      onChanged: onChanged,
    );

    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.pumpWidget(build(widget, TargetPlatform.android));
    debugDefaultTargetPlatformOverride = null;

    expect(find.text("foo"), findsOneWidget);
    expect(find.text("bar"), findsOneWidget);

    var fooCheckbox = find.byKey(Key("state_FOO"));
    expect(fooCheckbox, findsOneWidget);
    var barCheckbox = find.byKey(Key("state_BAR"));
    expect(barCheckbox, findsOneWidget);

    expect((tester.firstElement(fooCheckbox).widget as Checkbox).value, true);
    expect((tester.firstElement(barCheckbox).widget as Checkbox).value, false);

    expect(currentValue, null);
    await tester.tap(barCheckbox);
    expect((tester.firstElement(barCheckbox).widget as Checkbox).value, false);
    expect(currentValue, Set.of([Example.FOO, Example.BAR]));
  });

  testWidgets('Shows multiselect on iOS', (WidgetTester tester) async {
    final elementName = (Example e) => describeEnum(e).toLowerCase();
    var currentValue;
    final onChanged = (value) {
      Fimber.i("onChanged: $value");
      currentValue = value;
    };
    var widget = MultiSelect(
      elements: Example.values,
      selected: [Example.FOO],
      elementName: elementName,
      onChanged: onChanged,
    );

    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await tester.pumpWidget(build(widget, TargetPlatform.iOS));
    debugDefaultTargetPlatformOverride = null;

    expect(find.text("foo"), findsOneWidget);
    expect(find.text("bar"), findsOneWidget);

    var fooCheckmark = find.byKey(Key("state_FOO"));
    expect(fooCheckmark, findsOneWidget);
    var barCheckmark = find.byKey(Key("state_BAR"));
    expect(barCheckmark, findsOneWidget);

    expect((tester.firstElement(fooCheckmark).widget as Icon).icon,
        CupertinoIcons.check_mark_circled_solid);
    expect((tester.firstElement(barCheckmark).widget as Icon).icon,
        CupertinoIcons.circle);

    expect(currentValue, null);
    /* TODO this needs to be fixed, the tap action seems not to work
    var barChange = find.text("bar");
    await tester.ensureVisible(barChange);
    await tester.tap(barChange);
    expect((tester.firstElement(barCheckmark).widget as Icon).icon,
        CupertinoIcons.check_mark);
    expect(currentValue, Set.of([Example.FOO, Example.BAR]));
    */
  });
}
