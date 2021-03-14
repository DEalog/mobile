import 'package:json_annotation/json_annotation.dart';

part 'messages_meta.g.dart';

@JsonSerializable()
class MessagesMeta {
  @JsonKey(nullable: false, required: true)
  int size;
  @JsonKey(nullable: false, required: true)
  int number;
  @JsonKey(nullable: false, required: true)
  int totalElements;
  @JsonKey(nullable: false, required: true)
  int totalPages;

  MessagesMeta();

  factory MessagesMeta.fromJson(Map<String, dynamic> json) =>
      _$MessagesMetaFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesMetaToJson(this);
}
