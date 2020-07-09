import 'dart:io';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/messages.dart';
import 'screens/map/map.dart';
import 'screens/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return _buildPlatformScaffold(context);
  }

  Widget _buildPlatformScaffold(context) {
    if (Platform.isIOS) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: _cupertinoNavigation,
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) {
              return _buildScreen(index, context);
            },
          );
        },
      );
    }
    return Scaffold(
      body: _buildScreen(_currentIndex, context),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10.0,
        items: _materialNavigation,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  List<BottomNavigationBarItem> get _materialNavigation {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('navigation.home').tr(),
      ),
      BottomNavigationBarItem(
        icon: _buildMessagesIcon(),
        title: Text('navigation.messages').tr(),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        title: Text('navigation.map').tr(),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text('navigation.settings').tr(),
      ),
    ];
  }

  List<BottomNavigationBarItem> get _cupertinoNavigation {
    return [
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home),
        title: Text('navigation.home').tr(),
      ),
      BottomNavigationBarItem(
        icon: _buildMessagesIcon(),
        title: Text('navigation.messages').tr(),
      ),
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.location),
        title: Text('navigation.map').tr(),
      ),
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: Text('navigation.settings').tr(),
      ),
    ];
  }

  Badge _buildMessagesIcon() {
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
        Platform.isIOS ? CupertinoIcons.news : Icons.list,
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
