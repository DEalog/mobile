import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/version.dart';

import 'main.dart';
import 'screens/home.dart';
import 'screens/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int MAIN_TAB_INDEX = 0;
  static const int SETTINGS_TAB_INDEX = 1;

  final List<Widget> _children = [
    HomeScreen(),
    SettingsScreen(),
  ];

  final _items = (BuildContext context) => [
        BottomNavigationBarItem(
          title: Text('navigation.home').tr(),
          icon: Icon(context.platformIcons.home),
        ),
        BottomNavigationBarItem(
          title: Text('navigation.settings').tr(),
          icon: Icon(context.platformIcons.settings),
        ),
      ];

  // This needs to be captured here in a stateful widget
  PlatformTabController tabController;

  @override
  void initState() {
    super.initState();

    if (tabController == null) {
      tabController = PlatformTabController(initialIndex: MAIN_TAB_INDEX);
    }

    getIt.isReady<Version>().then((_) {
      final version = getIt<Version>();
      Fimber.i("version is ready: ${version.state.toString()}");

      if (version.state == VersionState.INITIAL) {
        Fimber.i("Open settings and start onboarding");
        tabController.setIndex(context, SETTINGS_TAB_INDEX);
        Fluttertoast.showToast(
          msg: Text("toast.first_run").tr().data,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Fimber.d("Building app");
    return _buildPlatformScaffold(context);
  }

  _buildScreen(int index, BuildContext context) {
    return Container(
      child: SafeArea(
        child: _children[index],
      ),
    );
  }

  Widget _buildPlatformScaffold(context) {
    return PlatformTabScaffold(
      iosContentPadding: true,
      tabController: tabController,
      bodyBuilder: (context, index) => _buildScreen(index, context),
      items: _items(context),
    );
  }
}
