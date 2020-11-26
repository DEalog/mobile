// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_hierarchy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionHierarchy _$RegionHierarchyFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['regionHierarchy']);
  return RegionHierarchy()
    ..regionHierarchy = (json['regionHierarchy'] as List)
        .map((e) => Region.fromJson(e as Map<String, dynamic>))
        .toList();
}
