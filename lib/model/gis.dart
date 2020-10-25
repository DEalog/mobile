import 'package:json_annotation/json_annotation.dart';

part 'gis.g.dart';

@JsonSerializable(nullable: false)
class Coordinate {
  final double longitude;
  final double latitude;

  Coordinate(this.longitude, this.latitude);

  factory Coordinate.fromJson(Map<String, dynamic> json) =>
      _$CoordinateFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinateToJson(this);
}