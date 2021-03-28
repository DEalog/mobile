import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/generated/codegen_loader.g.dart';
import 'package:mobile/themes.dart';

Future<void> createWidget(WidgetTester tester, Widget widget) async {
  final Brightness brightness = Brightness.light;
  await tester.pumpWidget(EasyLocalization(
    path: 'assets/translations',
    useOnlyLangCode: true,
    assetLoader: new CodegenLoader(),
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('en'),
    supportedLocales: [Locale('en')],
    saveLocale: false,
    useFallbackTranslations: true,
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
          home: PlatformScaffold(
            body: widget,
          ),
        ),
      ),
    ),
  ));
}

Future<void> createWidgetWrappedInColumn(
  WidgetTester tester,
  Widget widget,
) async {
  var widgetWrappedInColumn = Container(
    height: 500,
    child: Column(
      children: [widget],
    ),
  );
  await createWidget(tester, widgetWrappedInColumn);
}
