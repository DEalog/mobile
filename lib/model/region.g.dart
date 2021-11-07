// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Region _$RegionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['ars', 'name', 'type'],
  );
  return Region(
    json['ars'] as String,
    json['name'] as String,
    $enumDecode(_$RegionLevelEnumMap, json['type'],
        unknownValue: RegionLevel.UNKNOWN),
  );
}

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      'ars': instance.ars,
      'name': instance.name,
      'type': _$RegionLevelEnumMap[instance.type],
    };

const _$RegionLevelEnumMap = {
  RegionLevel.UNKNOWN: 'UNKNOWN',
  RegionLevel.COUNTRY: 'COUNTRY',
  RegionLevel.STATE: 'STATE',
  RegionLevel.COUNTY: 'COUNTY',
  RegionLevel.DISTRICT: 'DISTRICT',
  RegionLevel.MUNICIPALITY: 'MUNICIPALITY',
};
