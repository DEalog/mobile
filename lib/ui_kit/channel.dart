import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/model/channel.dart';

String categoryLocalizationKey(ChannelCategory category) =>
    "model.category.${describeEnum(category)}";

class ChannelView extends StatelessWidget {
  final Channel channel;

  ChannelView(this.channel);

  @override
  Widget build(BuildContext context) {
    Widget location;

    if (channel.location == null) {
      location = Icon(context.platformIcons.location);
    } else {
      location = Padding(
          padding: EdgeInsets.all(5.0), child: Text(channel.location.name));
    }
    location =
        Container(child: Center(child: location), padding: EdgeInsets.all(3.0));

    var categories = Wrap(
      children: channel.categories
          .map((e) => Padding(
                child: ChannelCategoryView(e),
                padding: EdgeInsets.all(2.0),
              ))
          .toList(),
    );

    return Row(
      children: <Widget>[location, categories],
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
