import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/model/region.dart';

import 'gis.dart';

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
    categoryLocalizationKey(category).tr();

@JsonSerializable(nullable: false)
class ChannelLocation {
  final String name;
  @JsonKey(nullable: true)
  final Coordinate coordinate;
  @JsonKey(nullable: true)
  final Region region;

  ChannelLocation(this.name, this.coordinate, this.region);

  ChannelLocation.empty() : this("", null, Region.empty());

  factory ChannelLocation.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  bool operator ==(o) =>
      o is ChannelLocation &&
      o.name == name &&
      o.coordinate == coordinate &&
      o.region == region;
}

Map<String, ChannelCategory> categoryMap = ChannelCategory.values
    .asMap()
    .map((key, value) => MapEntry(describeEnum(value), value));

@JsonSerializable(nullable: false)
class Channel {
  @JsonKey(nullable: true)
  final ChannelLocation location;
  @JsonKey(nullable: true)
  final Set<RegionLevel> levels;
  final Set<ChannelCategory> categories;

  Channel(this.location, this.levels, this.categories);

  Channel.deviceLocation(
      Set<RegionLevel> levels, Set<ChannelCategory> categories)
      : this(null, levels, categories);

  Channel.empty() : this(null, Set.of([]), Set.of([]));

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
