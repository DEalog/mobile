import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/generated/locale_keys.g.dart';
import 'package:mobile/model/channel.dart';

class LocationView extends StatelessWidget {
  final ChannelLocation location;
  final Alignment alignment;

  LocationView(this.location, {this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    Widget locationView;
    if (location.coordinate.isValid) {
      locationView = Row(
        key: Key('locationViewCurrentLocation'),
        children: [
          Icon(
            PlatformIcons(context).location,
          ),
          Text(
            LocaleKeys.settings_current_location.tr(),
            style: Theme.of(context)
                .textTheme
                .headline6
          ),
        ],
      );
    } else {
      var name = location.name;
      locationView = Padding(
          key: Key('locationViewStaticLocation'),
          padding: EdgeInsets.all(5.0),
          child: Text(
            name.isEmpty ? "n/a" : name,
            style: Theme.of(context)
                .textTheme
                .headline6,
          ));
    }
    return Container(
      key: Key('locationView'),
      alignment: this.alignment,
      child: locationView,
      padding: EdgeInsets.all(3.0),
    );
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
      children: <Widget>[
        LocationView(channel.location),
        Expanded(child: categories),
      ],
    );
  }
}

class ChannelCategoryView extends StatelessWidget {
  final ChannelCategory category;

  ChannelCategoryView(this.category);

  @override
  Widget build(BuildContext context) {
    var text = Text(
      categoryLocalizationKey(category).tr(),
    );
    return Container(
      child: text,
      decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      padding: EdgeInsets.all(4.0),
    );
  }
}
