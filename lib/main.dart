import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree());
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('de', 'DE'), Locale('en', 'US')],
      path: 'assets/translations',
      fallbackLocale: Locale('de', 'DE'),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  Widget _buildChild(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        theme: AppCupertinoTheme.theme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: Home(),
      );
    }
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      darkTheme: AppDarkTheme.theme,
      theme: AppLightTheme.theme,
      home: Home(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildChild(context);
  }
}
