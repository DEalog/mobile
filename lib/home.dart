import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'screens/messages.dart';
import 'screens/settings.dart';
import 'settings.dart';
import 'settings/wizard.dart';
import 'version.dart';
import 'main.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettings = getIt<AppSettings>();
    return FutureBuilder(
      future: getIt.allReady(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Fimber.i("Version isReady Snapshot ${snapshot.toString()}");
        if (snapshot.connectionState == ConnectionState.done) {
          final version = getIt<Version>();
          Fimber.i("version is ready: ${version.state.toString()}");
          // TODO: Route to onboarding screen
          if (version.state == VersionState.INITIAL) {}

          Fimber.d("Building app");
          return PlatformScaffold(
            material: (context, platform) =>
                MaterialScaffoldData(resizeToAvoidBottomInset: false),
            cupertino: (context, platform) => CupertinoPageScaffoldData(
              resizeToAvoidBottomInset: false,
            ),
            iosContentPadding: true,
            body: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    centerTitle: true,
                    title: Image.asset(
                      'assets/images/dealog_logo.png',
                      key: Key('DEalogLogoKey'),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    actions: [
                      PlatformIconButton(
                        key: Key('AppBarButtonSettings'),
                        icon: Icon(PlatformIcons(context).settings),
                        onPressed: () {
                          Navigator.of(context).push(
                            platformPageRoute(
                              builder: (BuildContext context) {
                                return SettingsScreen();
                              },
                              context: context,
                            ),
                          );
                        },
                      ),
                    ],
                    leading: PlatformButton(
                      materialFlat: (context, platform) =>
                          MaterialFlatButtonData(),
                      child: Icon(context.platformIcons.add),
                      onPressed: () => Navigator.of(context).push(
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) {
                            return ChannelWizard(
                              channelSettings: appSettings.channels,
                            );
                          },
                        ),
                      ),
                    ),
                    elevation: 0.0,
                    toolbarHeight: MediaQuery.of(context).size.height * 0.1,
                  ),
                  MessagesScreen()
                ],
              ),
            ),
          );
        } else {
          return PlatformCircularProgressIndicator();
        }
      },
    );
  }
}
