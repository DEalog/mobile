// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagesMeta _$MessagesMetaFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['size', 'number', 'totalElements', 'totalPages']);
  return MessagesMeta()
    ..size = json['size'] as int?
    ..number = json['number'] as int?
    ..totalElements = json['totalElements'] as int?
    ..totalPages = json['totalPages'] as int?;
}

Map<String, dynamic> _$MessagesMetaToJson(MessagesMeta instance) =>
    <String, dynamic>{
      'size': instance.size,
      'number': instance.number,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
    };
