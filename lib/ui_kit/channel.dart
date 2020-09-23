import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/model/channel.dart';

String categoryLocalizationKey(ChannelCategory category) =>
    "model.category.${describeEnum(category)}";

class LocationView extends StatelessWidget {
  final Location location;

  LocationView(this.location);

  @override
  Widget build(BuildContext context) {
    Widget locationView;
    if (location == null) {
      locationView = Icon(PlatformIcons(context).location);
    } else {
      locationView =
          Padding(padding: EdgeInsets.all(5.0), child: Text(location.name));
    }
    return Container(
        child: Center(child: locationView), padding: EdgeInsets.all(3.0));
  }
}

class ChannelView extends StatelessWidget {
  final Channel channel;

  ChannelView(this.channel);

  @override
  Widget build(BuildContext context) {
    var categories = Wrap(
      children: channel.categories
          .map((e) => Padding(
                child: ChannelCategoryView(e),
                padding: EdgeInsets.all(2.0),
              ))
          .toList(),
    );

    return Row(
      children: <Widget>[LocationView(channel.location), categories],
    );
  }
}

class ChannelCategoryView extends StatelessWidget {
  final ChannelCategory category;

  ChannelCategoryView(this.category);

  @override
  Widget build(BuildContext context) {
    var text = Text(
      categoryLocalizationKey(category),
      style: TextStyle(fontSize: 12),
    ).tr();
    return Container(
      child: text,
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      padding: EdgeInsets.all(4.0),
    );
  }
}
