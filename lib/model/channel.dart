import 'dart:convert';

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

Map<String, ChannelCategory> _categoryMap = ChannelCategory.values
    .asMap()
    .map((key, value) => MapEntry(describeEnum(value), value));

class Channel {
  final Location location;
  final List<ChannelCategory> categories;

  Channel(this.location, this.categories);

  Channel.deviceLocation(List<ChannelCategory> categories)
      : this(null, categories);

  static fromJson(String json) {
    Map decoded = jsonDecode(json);
    String location = decoded['location'];
    List<dynamic> categories = decoded['categories'];
    if (categories == null) {
      categories = List.empty();
    }
    return Channel(location != null ? Location(location, 0.0, 0.0) : null,
        categories.map((e) => _categoryMap[e]).toList(growable: false));
  }
}