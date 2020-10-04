import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/generated/codegen_loader.g.dart';
import 'home.dart';
import 'locator.dart';
import 'themes.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree());
  register(getIt);

  runApp(localized(App()));
}

Widget localized(Widget widget) {
  return EasyLocalization(
    supportedLocales: [Locale('de'), Locale('en')],
    path: 'assets/translations',
    assetLoader: CodegenLoader(),
    fallbackLocale: Locale('de', 'DE'),
    child: widget,
  );
}

class App extends StatelessWidget {
  final Brightness brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: brightness == Brightness.light
            ? AppLightTheme.theme
            : AppDarkTheme.theme,
        child: PlatformProvider(
          builder: (context) => PlatformApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'Dealog',
            material: (_, __) {
              return new MaterialAppData(
                  theme: AppLightTheme.theme,
                  darkTheme: AppDarkTheme.theme,
                  themeMode: ThemeMode.system);
            },
            cupertino: (_, __) => new CupertinoAppData(
                theme: AppCupertinoTheme.theme,
                localizationsDelegates: [
                  DefaultCupertinoLocalizations.delegate
                ]),
            home: Home(),
          ),
        ));
  }
}
