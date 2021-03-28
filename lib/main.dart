import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/generated/codegen_loader.g.dart';
import 'package:mobile/screens/settings.dart';
import 'package:mobile/settings/wizard.dart';

import 'home.dart';
import 'locator.dart';
import 'app_settings.dart';
import 'themes.dart';
import 'version.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Fimber.plantTree(DebugTree());
  register(getIt);

  // Force portrait mode
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
    final materialLightTheme = AppLightTheme.theme;
    // final materialDarkTheme = AppDarkTheme.theme; // enable for darkmode
    final version = getIt<Version>();
    final AppSettings appSettings = getIt<AppSettings>();
    final settings = PlatformSettingsData(iosUsesMaterialWidgets: false);
    Fimber.i("version is ready: ${version.state.toString()}");

    return Theme(
      data: brightness == Brightness.light
          ? materialLightTheme
          : materialLightTheme, // materialDarkTheme when enabling darkmode
      child: PlatformProvider(
        settings: settings,
        builder: (context) => PlatformApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'DEalog Pilot',
          material: (_, __) {
            return new MaterialAppData(
              theme: materialLightTheme,
              // darkTheme: materialDarkTheme, // enable for darkmode
              themeMode: ThemeMode.light,
            );
          },
          cupertino: (_, __) => new CupertinoAppData(
            theme: AppCupertinoTheme.theme,
          ),
          initialRoute: version.isInitialVersion ? '/wizard' : '/',
          routes: {
            '/': (context) => new Home(),
            '/wizard': (context) => new ChannelWizard(
                  appSettings.channels,
                ),
            '/settings': (context) => new SettingsScreen(),
          },
        ),
      ),
    );
  }
}
