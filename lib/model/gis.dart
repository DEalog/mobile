import 'package:json_annotation/json_annotation.dart';

part 'gis.g.dart';

@JsonSerializable()
class Coordinate {
  final double longitude;
  final double latitude;

  Coordinate(this.longitude, this.latitude);

  Coordinate.invalid() : this(181, 91);

  bool get isValid =>
      longitude <= 180 &&
      longitude >= -180 &&
      latitude <= 90 &&
      latitude >= -90;

  factory Coordinate.fromJson(Map<String, dynamic> json) =>
      _$CoordinateFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinateToJson(this);

  @override
  int get hashCode => longitude.hashCode ^ latitude.hashCode;

  @override
  bool operator ==(o) =>
      o is Coordinate && o.longitude == longitude && o.latitude == latitude;
}
