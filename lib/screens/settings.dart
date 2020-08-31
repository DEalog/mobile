import 'package:flutter/material.dart';
import 'package:mobile/settings.dart';
import 'package:mobile/settings/channel.dart';

import '../main.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettings = getIt<AppSettings>();
    return Container(
        child: ListView(children: [ChannelSettings(appSettings.locations)]));
  }
}
