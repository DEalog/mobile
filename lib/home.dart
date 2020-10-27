import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'screens/messages.dart';
import 'screens/settings.dart';
import 'version.dart';
import 'main.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    leading: PlatformIconButton(
                      key: Key('AppBarButtonDehaze'),
                      icon: Icon(PlatformIcons(context).dehaze),
                      onPressed: () {
                        Navigator.push(
                          context,
                          platformPageRoute(
                              builder: (BuildContext context) {
                                return SettingsScreen();
                              },
                              context: context),
                        );
                      },
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
