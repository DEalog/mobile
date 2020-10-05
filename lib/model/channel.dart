import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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

String categoryLocalizationKey(ChannelCategory category) =>
    "model.categories.${describeEnum(category)}";

String categoryName(ChannelCategory category) =>
    Text(categoryLocalizationKey(category)).tr().data;

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

  Location.empty() : this("", 0.0, 0.0);

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
  final Set<ChannelCategory> categories;

  Channel(this.location, this.categories);

  Channel.deviceLocation(Set<ChannelCategory> categories)
      : this(null, categories);

  Channel.empty() : this(null, Set.of([]));

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
