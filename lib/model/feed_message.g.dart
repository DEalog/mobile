// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedMessage _$FeedMessageFromJson(Map<String, dynamic> json) {
  return FeedMessage(
    identifier: json['identifier'] as String?,
    organization: json['organization'] as String?,
    headline: json['headline'] as String?,
    description: json['description'] as String?,
    ars: json['ars'] as String?,
    category: json['category'] as String?,
    publishedAt: json['publishedAt'] as String?,
  );
}

Map<String, dynamic> _$FeedMessageToJson(FeedMessage instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'organization': instance.organization,
      'headline': instance.headline,
      'description': instance.description,
      'ars': instance.ars,
      'category': instance.category,
      'publishedAt': instance.publishedAt,
    };
