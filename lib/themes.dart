import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDarkTheme {
  static get theme {
    Fimber.d("Setting theme: dark");

    return ThemeData.dark().copyWith(
      primaryColor: Colors.grey[900],
    );
  }
}

class AppLightTheme {
  static get theme {
    Fimber.d("Setting theme: light");

    return ThemeData.light().copyWith(
      primaryColor: Colors.black,
    );
  }
}

// TODO Cupertino behaves differently for light and dark mode.
class AppCupertinoTheme {
  static get theme {
    Fimber.d("Setting theme: cupertino");
    Brightness brightness = Brightness.light;

    final original = CupertinoThemeData(
      brightness: brightness,
      primaryColor: CupertinoDynamicColor.withBrightness(
        color: Colors.white,
        darkColor: Colors.black,
      ),
    );

    return original;
  }
}
