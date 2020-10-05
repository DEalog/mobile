// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    json['name'] as String,
    (json['longitude'] as num).toDouble(),
    (json['latitude'] as num).toDouble(),
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'name': instance.name,
    };

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return Channel(
    json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    (json['categories'] as List)
        .map((e) => _$enumDecode(_$ChannelCategoryEnumMap, e))
        .toSet(),
  );
}

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'location': instance.location,
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
