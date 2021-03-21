import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/model/region.dart';

import 'regions_meta.dart';

part 'regions.g.dart';

@JsonSerializable()
class Regions {
  @JsonKey(required: true, name: "content")
  List<Region>? regions;
  @JsonKey(required: true)
  RegionsMeta? meta;

  Regions();

  factory Regions.fromJson(Map<String, dynamic> json) =>
      _$RegionsFromJson(json);

  Map<String, dynamic> toJson() => _$RegionsToJson(this);
}
