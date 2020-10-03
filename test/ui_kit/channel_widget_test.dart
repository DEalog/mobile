import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/ui_kit/channel.dart';

import '../support.dart';

void main() {
  testWidgets('Shows location place icon', (WidgetTester tester) async {
    await createWidget(tester, LocationView(null));
    await tester.pumpAndSettle();

    expect(find.byWidgetPredicate((Widget widget) => widget is Icon),
        findsWidgets);
  });

  testWidgets('Shows location name', (WidgetTester tester) async {
    await createWidget(tester, LocationView(Location("Foo", 0.0, 0.0)));
    await tester.pumpAndSettle();

    expect(find.text("Foo"), findsOneWidget);
  });

  testWidgets('Shows channel location name', (WidgetTester tester) async {
    var channel = Channel(Location("Foo", 0.0, 0.0), List.empty());

    await createWidget(tester, ChannelView(channel));
    await tester.pumpAndSettle();

    expect(find.text("Foo"), findsOneWidget);
  });

  testWidgets('Shows category', (WidgetTester tester) async {
    await createWidget(tester, ChannelCategoryView(ChannelCategory.FIRE));
    await tester.pumpAndSettle();

    expect(find.text("Fire"), findsOneWidget);
  });

  testWidgets('Shows single category in channel', (WidgetTester tester) async {
    var channel = Channel(null, List.of([ChannelCategory.FIRE]));

    await createWidget(tester, ChannelView(channel));
    await tester.pumpAndSettle();

    expect(find.text("Fire"), findsOneWidget);
  });

  testWidgets('Shows two categories in channel', (WidgetTester tester) async {
    var channel =
        Channel(null, List.of([ChannelCategory.FIRE, ChannelCategory.HEALTH]));

    await createWidget(tester, ChannelView(channel));
    await tester.pumpAndSettle();

    expect(find.text("Fire"), findsOneWidget);
    expect(find.text("Health"), findsOneWidget);
  });
}
