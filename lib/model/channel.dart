import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/model/ars.dart';

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
class Location {
  final String name;
  @JsonKey(nullable: true)
  final Coordinate coordinate;
  @JsonKey(nullable: true)
  final Map<ArsLevel, String> levels;

  Location(this.name, this.coordinate, this.levels);

  Location.empty() : this("", null, Map.fromIterable([]));

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
  @JsonKey(nullable: true)
  final Set<ArsLevel> levels;
  final Set<ChannelCategory> categories;

  Channel(this.location, this.levels, this.categories);

  Channel.deviceLocation(Set<ArsLevel> levels, Set<ChannelCategory> categories)
      : this(null, levels, categories);

  Channel.empty() : this(null, Set.of([]), Set.of([]));

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
