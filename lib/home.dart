import 'dart:io';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'screens/home.dart';
import 'screens/messages.dart';
import 'screens/map.dart';
import 'screens/settings.dart';

class Home extends StatefulWidget {
  Home(this.toggleBrightness);

  final void Function() toggleBrightness;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    MessagesScreen(),
    MapScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Fimber.d("Building app");
    return _buildGenericPlatformScaffold(context);
  }

  Widget _buildGenericPlatformScaffold(context) {
    final tabController = PlatformTabController(
      initialIndex: 1,
    );
    final items = _navigation(context);

    return PlatformTabScaffold(
      iosContentPadding: true,
      tabController: tabController,
      appBarBuilder: (_, index) => PlatformAppBar(
        title: items[index].title,
        cupertino: (_, __) => CupertinoNavigationBarData(
          title: items[index].title,
          //   only required if useCupertinoTabView = false,
          transitionBetweenRoutes: false,
        ),
      ),
      bodyBuilder: (context, index) => _children[index],
      items: items,
      cupertino: (_, __) => CupertinoTabScaffoldData(
        //   Having this property as false (default true) forces it not to use CupertinoTabView which will show
        //   the back button, but does required transitionBetweenRoutes set to false (see above)
        useCupertinoTabView: false,
      ),
    );

  }

  List<BottomNavigationBarItem> _navigation(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: Icon(context.platformIcons.home),
        title: Text('navigation.home').tr(),
      ),
      BottomNavigationBarItem(
        icon: _buildMessagesIcon(context),
        title: Text('navigation.messages').tr(),
      ),
      BottomNavigationBarItem(
        icon: Icon(context.platformIcons.location),
        title: Text('navigation.map').tr(),
      ),
      BottomNavigationBarItem(
        icon: Icon(context.platformIcons.settings),
        title: Text('navigation.settings').tr(),
      ),
    ];
  }

  Badge _buildMessagesIcon(BuildContext context) {
    return Badge(
      animationDuration: Duration.zero,
      shape: BadgeShape.square,
      borderRadius: 20,
      position: BadgePosition.topLeft(top: 0, left: 15),
      showBadge: true,
      badgeContent: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Text(
          '1',
          style: TextStyle(
            fontSize: 10.0,
            color: Theme.of(context).buttonColor,
          ),
        ),
      ),
      child: Icon(
        isMaterial(context) ? Icons.list : CupertinoIcons.news,
      ),
    );
  }

  _buildScreen(int index, BuildContext context) {
    return Container(
      child: SafeArea(
        child: _children[index],
      ),
    );
  }
}
