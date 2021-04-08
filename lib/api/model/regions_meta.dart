import 'package:json_annotation/json_annotation.dart';

part 'regions_meta.g.dart';

@JsonSerializable()
class RegionsMeta {
  @JsonKey(required: true)
  int? size;
  @JsonKey(required: true)
  int? number;
  @JsonKey(required: true)
  int? totalElements;
  @JsonKey(required: true)
  int? totalPages;

  RegionsMeta();

  factory RegionsMeta.fromJson(Map<String, dynamic> json) =>
      _$RegionsMetaFromJson(json);

  Map<String, dynamic> toJson() => _$RegionsMetaToJson(this);
}
