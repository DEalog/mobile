import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'channel.g.dart';

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

@JsonSerializable(nullable: false)
class Location extends Coordinate {
  final String name;

  Location(this.name, double longitude, double latitude)
      : super(longitude, latitude);

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

Map<String, ChannelCategory> categoryMap = ChannelCategory.values
    .asMap()
    .map((key, value) => MapEntry(describeEnum(value), value));

@JsonSerializable(nullable: false)
class Channel {
  @JsonKey(nullable: true)
  final Location location;
  final List<ChannelCategory> categories;

  Channel(this.location, this.categories);

  Channel.deviceLocation(List<ChannelCategory> categories)
      : this(null, categories);

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
