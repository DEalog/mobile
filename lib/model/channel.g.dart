// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelLocation _$ChannelLocationFromJson(Map<String, dynamic> json) {
  return ChannelLocation(
    json['name'] as String,
    Coordinate.fromJson(json['coordinate'] as Map<String, dynamic>),
    Region.fromJson(json['region'] as Map<String, dynamic>),
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
    ChannelLocation.fromJson(json['location'] as Map<String, dynamic>),
    (json['levels'] as List<dynamic>)
        .map((e) => _$enumDecode(_$RegionLevelEnumMap, e))
        .toSet(),
    (json['regionhierarchy'] as List<dynamic>)
        .map((e) => Region.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['categories'] as List<dynamic>)
        .map((e) => _$enumDecode(_$ChannelCategoryEnumMap, e))
        .toSet(),
  );
}

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'location': instance.location,
      'levels': instance.levels.map((e) => _$RegionLevelEnumMap[e]).toList(),
      'regionhierarchy': instance.regionhierarchy,
      'categories':
          instance.categories.map((e) => _$ChannelCategoryEnumMap[e]).toList(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
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
