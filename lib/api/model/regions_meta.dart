import 'package:json_annotation/json_annotation.dart';

part 'regions_meta.g.dart';

@JsonSerializable()
class RegionsMeta {
  @JsonKey(nullable: false, required: true)
  int size;
  @JsonKey(nullable: false, required: true)
  int number;
  @JsonKey(nullable: false, required: true)
  int totalElements;
  @JsonKey(nullable: false, required: true)
  int totalPages;

  RegionsMeta();

  factory RegionsMeta.fromJson(Map<String, dynamic> json) =>
      _$RegionsMetaFromJson(json);

  Map<String, dynamic> toJson() => _$RegionsMetaToJson(this);
}
