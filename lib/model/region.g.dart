// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Region _$RegionFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['ars', 'name', 'type']);
  return Region(
    json['ars'] as String,
    json['name'] as String,
    _$enumDecode(_$RegionLevelEnumMap, json['type'],
        unknownValue: RegionLevel.UNKNOWN),
  );
}

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      'ars': instance.ars,
      'name': instance.name,
      'type': _$RegionLevelEnumMap[instance.type],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$RegionLevelEnumMap = {
  RegionLevel.UNKNOWN: 'UNKNOWN',
  RegionLevel.COUNTRY: 'COUNTRY',
  RegionLevel.STATE: 'STATE',
  RegionLevel.COUNTY: 'COUNTY',
  RegionLevel.DISTRICT: 'DISTRICT',
  RegionLevel.MUNICIPALITY: 'MUNICIPALITY',
};
