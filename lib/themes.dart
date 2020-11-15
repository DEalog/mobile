import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLightTheme {
  static get theme {
    Fimber.d("Setting theme: light");

    return new ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.white,
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
        ),
        color: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class AppDarkTheme {
  static get theme {
    Fimber.d("Setting theme: dark");

    return new ThemeData(
      primarySwatch: Colors.grey,
      brightness: Brightness.dark,
      accentColor: Colors.blue,
    );
  }
}

class AppCupertinoTheme {
  static get theme {
    Fimber.d("Setting theme: cupertino");
    return new CupertinoThemeData(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      barBackgroundColor: Colors.white,
      primaryContrastingColor: Colors.white,
    );
  }
}
