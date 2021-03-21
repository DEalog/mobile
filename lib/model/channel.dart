import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/model/region.dart';
import 'gis.dart';

part 'channel.g.dart';

int foldSetHashCode(Set anySet) => anySet.fold(
    0, (previousValue, element) => previousValue ^ element.hashCode);

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

String categoryName(ChannelCategory? category) =>
    categoryLocalizationKey(category!).tr();

@JsonSerializable()
class ChannelLocation {
  final String? name;
  @JsonKey()
  final Coordinate? coordinate;
  @JsonKey()
  final Region? region;

  ChannelLocation(this.name, this.coordinate, this.region);

  ChannelLocation.empty() : this("", null, Region.empty());

  bool get isEmpty => this.name == '' && this.coordinate == null && this.region!.isEmpty;

  factory ChannelLocation.fromJson(Map<String, dynamic> json) =>
      _$ChannelLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelLocationToJson(this);

  @override
  int get hashCode => name.hashCode ^ coordinate.hashCode ^ region.hashCode;

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

@JsonSerializable()
class Channel {
  @JsonKey()
  final ChannelLocation? location;
  @JsonKey()
  final Set<RegionLevel?>? levels;
  @JsonKey()
  final List<Region>? regionhierarchy;
  final Set<ChannelCategory?>? categories;

  Channel(this.location, this.levels, this.regionhierarchy, this.categories);

  Channel.deviceLocation(
      Set<RegionLevel> levels, Set<ChannelCategory> categories)
      : this(null, levels, null, categories);

  Channel.empty()
      : this(
          ChannelLocation.empty(),
          Set.of([]),
          List.empty(),
          Set.of([]),
        );

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);

  @override
  int get hashCode =>
      (location == null ? 0 : location.hashCode) ^ (levels == null ? 0 : foldSetHashCode(levels!)) ^ foldSetHashCode(categories!);

  @override
  bool operator ==(o ) {
    return o is Channel &&
        o.location == location &&
        setEquals(o.levels, levels) &&
        setEquals(o.categories, categories);
  }
}
