import 'package:flutter/foundation.dart';

enum ChannelCategory {
  GEO,
  MET,
  SAFETY,
  SECURITY,
  RESCUE,
  FIRE,
  HEALTH,
  ENV,
  TRANSPORT,
  INFRA,
  CBRNE,
  OTHER
}

class Coordinate {
  final double longitude;
  final double latitude;

  Coordinate(this.longitude, this.latitude);
}

class Location extends Coordinate {
  final String name;

  Location(this.name, double longitude, double latitude)
      : super(longitude, latitude);
}

Map<String, ChannelCategory> categoryMap = ChannelCategory.values
    .asMap()
    .map((key, value) => MapEntry(describeEnum(value), value));

class Channel {
  final Location location;
  final List<ChannelCategory> categories;

  Channel(this.location, this.categories);

  Channel.deviceLocation(List<ChannelCategory> categories)
      : this(null, categories);
}
