// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Messages _$MessagesFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['content', 'meta']);
  return Messages()
    ..messages = (json['content'] as List<dynamic>?)
        ?.map((e) => FeedMessage.fromJson(e as Map<String, dynamic>))
        .toList()
    ..meta = json['meta'] == null
        ? null
        : MessagesMeta.fromJson(json['meta'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MessagesToJson(Messages instance) => <String, dynamic>{
      'content': instance.messages,
      'meta': instance.meta,
    };
