import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/generated/codegen_loader.g.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/themes.dart';
import 'package:mobile/ui_kit/channel.dart';

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

    WidgetPredicate channelCategory =
        (Widget widget) => widget is ChannelCategoryView;

    expect(find.text("Fire"), findsOneWidget);
    expect(find.text("Health"), findsOneWidget);
  });
}

Future<void> createWidget(WidgetTester tester, Widget widget) async {
  final Brightness brightness = Brightness.light;
  await tester.pumpWidget(EasyLocalization(
    path: 'unused',
    useOnlyLangCode: true,
    assetLoader: CodegenLoader(),
    fallbackLocale: const Locale('en_US'),
    supportedLocales: [Locale('en')],
    saveLocale: false,
    child: Theme(
      data: brightness == Brightness.light
          ? AppLightTheme.theme
          : AppDarkTheme.theme,
      child: PlatformProvider(
        builder: (context) => PlatformApp(
          // Old - localizationsDelegates: context.localizationDelegates,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          title: 'Dealog',
          material: (_, __) {
            return new MaterialAppData(
              theme: AppLightTheme.theme,
              darkTheme: AppDarkTheme.theme,
              themeMode: brightness == Brightness.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
            );
          },
          cupertino: (_, __) => new CupertinoAppData(
            theme: AppCupertinoTheme.theme,
          ),
          home: widget,
        ),
      ),
    ),
  ));
}
