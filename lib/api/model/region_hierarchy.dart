import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/model/region.dart';

part 'region_hierarchy.g.dart';

@JsonSerializable(createToJson: false)
class RegionHierarchy {
  @JsonKey(nullable: false, required: true)
  List<Region> regionHierarchy;

  RegionHierarchy();

  factory RegionHierarchy.fromJson(Map<String, dynamic> json) =>
      _$RegionHierarchyFromJson(json);
}
