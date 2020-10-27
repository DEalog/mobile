import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/settings.dart';
import 'package:mobile/settings/channel.dart';

import '../main.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettings = getIt<AppSettings>();
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
                key: Key('AppBarButtonBack'),
                icon: Icon(PlatformIcons(context).back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              elevation: 0.0,
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              height: 200,
              child: ListView(
                children: [
                  ChannelSettings(appSettings.channels),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
