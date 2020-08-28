import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'screens/home.dart';
import 'screens/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _children = [
    HomeScreen(),
    SettingsScreen(),
  ];

  static final _titles = ['navigation.home', 'navigation.settings'];
  final _items = (BuildContext context) => [
        BottomNavigationBarItem(
          title: Text(_titles[0]).tr(),
          icon: Icon(PlatformIcons(context).home),
        ),
        BottomNavigationBarItem(
          title: Text(_titles[1]).tr(),
          icon: Icon(PlatformIcons(context).settings),
        ),
      ];

  // This needs to be captured here in a stateful widget
  PlatformTabController tabController;

  @override
  void initState() {
    super.initState();

    // If you want further control of the tabs have one of these
    if (tabController == null) {
      tabController = PlatformTabController(
        initialIndex: 0,
      );
    }
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
