// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelLocation _$ChannelLocationFromJson(Map<String, dynamic> json) {
  return ChannelLocation(
    json['name'] as String,
    json['coordinate'] == null
        ? null
        : Coordinate.fromJson(json['coordinate'] as Map<String, dynamic>),
    json['region'] == null
        ? null
        : Region.fromJson(json['region'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ChannelLocationToJson(ChannelLocation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'coordinate': instance.coordinate,
      'region': instance.region,
    };

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return Channel(
    json['location'] == null
        ? null
        : ChannelLocation.fromJson(json['location'] as Map<String, dynamic>),
    (json['levels'] as List)
        ?.map((e) => _$enumDecodeNullable(_$RegionLevelEnumMap, e))
        ?.toSet(),
    (json['regionhierarchy'] as List)
        ?.map((e) =>
            e == null ? null : Region.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['categories'] as List)
        .map((e) => _$enumDecode(_$ChannelCategoryEnumMap, e))
        .toSet(),
  );
}

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'location': instance.location,
      'levels': instance.levels?.map((e) => _$RegionLevelEnumMap[e])?.toList(),
      'regionhierarchy': instance.regionhierarchy,
      'categories':
          instance.categories.map((e) => _$ChannelCategoryEnumMap[e]).toList(),
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

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$RegionLevelEnumMap = {
  RegionLevel.UNKNOWN: 'UNKNOWN',
  RegionLevel.COUNTRY: 'COUNTRY',
  RegionLevel.STATE: 'STATE',
  RegionLevel.COUNTY: 'COUNTY',
  RegionLevel.DISTRICT: 'DISTRICT',
  RegionLevel.MUNICIPALITY: 'MUNICIPALITY',
};

const _$ChannelCategoryEnumMap = {
  ChannelCategory.GEO: 'GEO',
  ChannelCategory.MET: 'MET',
  ChannelCategory.SAFETY: 'SAFETY',
  ChannelCategory.SECURITY: 'SECURITY',
  ChannelCategory.RESCUE: 'RESCUE',
  ChannelCategory.FIRE: 'FIRE',
  ChannelCategory.HEALTH: 'HEALTH',
  ChannelCategory.ENV: 'ENV',
  ChannelCategory.TRANSPORT: 'TRANSPORT',
  ChannelCategory.INFRA: 'INFRA',
  ChannelCategory.CBRNE: 'CBRNE',
  ChannelCategory.OTHER: 'OTHER',
};
