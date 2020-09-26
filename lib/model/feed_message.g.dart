// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedMessage _$FeedMessageFromJson(Map<String, dynamic> json) {
  return FeedMessage(
    identifier: json['identifier'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$FeedMessageToJson(FeedMessage instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'description': instance.description,
    };
