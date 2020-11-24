// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Regions _$RegionsFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['content', 'meta']);
  return Regions()
    ..regions = (json['content'] as List)
        .map((e) => Region.fromJson(e as Map<String, dynamic>))
        .toList()
    ..meta = RegionsMeta.fromJson(json['meta'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RegionsToJson(Regions instance) => <String, dynamic>{
      'content': instance.regions,
      'meta': instance.meta,
    };
