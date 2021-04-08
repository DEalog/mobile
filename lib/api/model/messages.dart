import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/model/feed_message.dart';

import 'messages_meta.dart';

part 'messages.g.dart';

@JsonSerializable()
class Messages {
  @JsonKey(
    required: true,
    name: "content",
  )
  List<FeedMessage>? messages;
  @JsonKey(
    required: true,
  )
  MessagesMeta? meta;

  Messages();

  factory Messages.fromJson(Map<String, dynamic> json) =>
      _$MessagesFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesToJson(this);
}
