// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regions_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionsMeta _$RegionsMetaFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['size', 'number', 'totalElements', 'totalPages'],
  );
  return RegionsMeta()
    ..size = json['size'] as int?
    ..number = json['number'] as int?
    ..totalElements = json['totalElements'] as int?
    ..totalPages = json['totalPages'] as int?;
}

Map<String, dynamic> _$RegionsMetaToJson(RegionsMeta instance) =>
    <String, dynamic>{
      'size': instance.size,
      'number': instance.number,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
    };
