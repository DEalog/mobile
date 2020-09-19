import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadingItem {
  final String heading;

  HeadingItem(this.heading);

  Widget build(BuildContext context) {
    final child = Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    ).tr();
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
        child: child);
  }
}

class AlertItem {
  final String message;

  AlertItem(this.message);

  Widget build(BuildContext context) {
    final child = Text(
      message,
      style: Theme.of(context).textTheme.headline6,
    ).tr();
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
        color: Theme.of(context).focusColor,
        child: child);
  }
}
