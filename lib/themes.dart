import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AppTheme { Light, Dark, System }

final appThemeData = {
  ThemeMode.dark: AppDarkTheme.theme,
  ThemeMode.light: AppLightTheme.theme,
  ThemeMode.system: AppLightTheme.theme,
};

class AppDarkTheme {
  static get theme {
    Fimber.d("Setting theme: dark");
    final original = ThemeData.dark();

    return original.copyWith(
      primaryColor: Colors.grey[900],
      accentColor: Colors.grey[200],
      textSelectionColor: Colors.grey[100],
      scaffoldBackgroundColor: Colors.grey[900],
      canvasColor: Colors.black,
    );
  }
}

class AppLightTheme {
  static get theme {
    Fimber.d("Setting theme: light");
    final original = ThemeData.light();
    final primaryTextTheme = original.primaryTextTheme.copyWith(
      headline6: original.primaryTextTheme.headline6.copyWith(
        color: Colors.grey[700],
      ),
    );
    final primaryIconTheme = original.primaryIconTheme.copyWith(
      color: Colors.grey[700],
    );

    return original.copyWith(
      primaryTextTheme: primaryTextTheme,
      primaryIconTheme: primaryIconTheme,
      primaryColor: Colors.grey[900],
      accentColor: Colors.grey[200],
      buttonColor: Colors.grey[100],
      scaffoldBackgroundColor: Colors.grey[300],
      canvasColor: Colors.grey[200],
    );
  }
}

// TODO Cupertino behaves differently for light and dark mode.
class AppCupertinoTheme {
  static get theme {
    Fimber.d("Setting theme: cupertino");
    final original = CupertinoThemeData();

    return original.copyWith();
  }
}
