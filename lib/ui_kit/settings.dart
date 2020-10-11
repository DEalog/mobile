import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HeadingItem {
  final String heading;

  HeadingItem(this.heading);

  Widget build(BuildContext context) {
    var textStyle;
    if (isMaterial(context)) {
      textStyle = Theme.of(context).textTheme.headline5;
    } else {
      textStyle = CupertinoTheme.of(context).textTheme.actionTextStyle;
    }
    final child = Text(
      heading.tr(),
      style: textStyle,
    );
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
    var textStyle;
    if (isMaterial(context)) {
      textStyle = Theme.of(context).textTheme.headline6;
    } else {
      textStyle = CupertinoTheme.of(context).textTheme.actionTextStyle;
    }
    final child = Text(
      message.tr(),
      style: textStyle,
    );
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
        color: Theme.of(context).focusColor,
        child: child);
  }
}
