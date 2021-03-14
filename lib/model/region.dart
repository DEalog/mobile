import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'region.g.dart';

enum RegionLevel {
  UNKNOWN,
  COUNTRY,
  STATE,
  COUNTY,
  DISTRICT,
  MUNICIPALITY,
}

String regionLevelLocalizationKey(RegionLevel regionLevel) =>
    "model.levels.${describeEnum(regionLevel)}";

String regionLevelName(RegionLevel regionLevel) =>
    regionLevelLocalizationKey(regionLevel).tr();

@JsonSerializable(nullable: false)
class Region {
  @JsonKey(nullable: false, required: true)
  String ars;
  @JsonKey(nullable: false, required: true)
  String name;
  @JsonKey(
      nullable: false, required: true, unknownEnumValue: RegionLevel.UNKNOWN)
  RegionLevel type;

  Region(this.ars, this.name, this.type);

  Region.empty() : this("", "", RegionLevel.UNKNOWN);

  bool get isEmpty => name == '' || ars == '' || type == RegionLevel.UNKNOWN;

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);

  Map<String, dynamic> toJson() => _$RegionToJson(this);

  @override
  int get hashCode => ars.hashCode ^ name.hashCode ^ type.hashCode;

  @override
  bool operator ==(o) =>
      o is Region && o.ars == ars && o.name == name && o.type == type;
}
