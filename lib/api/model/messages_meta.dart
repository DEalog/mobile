import 'package:json_annotation/json_annotation.dart';

part 'messages_meta.g.dart';

@JsonSerializable()
class MessagesMeta {
  @JsonKey(required: true)
  int? size;
  @JsonKey(required: true)
  int? number;
  @JsonKey(required: true)
  int? totalElements;
  @JsonKey(required: true)
  int? totalPages;

  MessagesMeta();

  factory MessagesMeta.fromJson(Map<String, dynamic> json) =>
      _$MessagesMetaFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesMetaToJson(this);
}
