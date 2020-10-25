// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    json['name'] as String,
    json['coordinate'] == null
        ? null
        : Coordinate.fromJson(json['coordinate'] as Map<String, dynamic>),
    (json['levels'] as Map<String, dynamic>)?.map(
      (k, e) =>
          MapEntry(_$enumDecodeNullable(_$ArsLevelEnumMap, k), e as String),
    ),
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'name': instance.name,
      'coordinate': instance.coordinate,
      'levels':
          instance.levels?.map((k, e) => MapEntry(_$ArsLevelEnumMap[k], e)),
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

const _$ArsLevelEnumMap = {
  ArsLevel.COUNTRY: 'COUNTRY',
  ArsLevel.STATE: 'STATE',
  ArsLevel.COUNTY: 'COUNTY',
  ArsLevel.DISTRICT: 'DISTRICT',
  ArsLevel.MUNICIPALITY: 'MUNICIPALITY',
};

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return Channel(
    json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    (json['levels'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ArsLevelEnumMap, e))
        ?.toSet(),
    (json['categories'] as List)
        .map((e) => _$enumDecode(_$ChannelCategoryEnumMap, e))
        .toSet(),
  );
}

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'location': instance.location,
      'levels': instance.levels?.map((e) => _$ArsLevelEnumMap[e])?.toList(),
      'categories':
          instance.categories.map((e) => _$ChannelCategoryEnumMap[e]).toList(),
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
