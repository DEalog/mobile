import 'package:json_annotation/json_annotation.dart';

part 'feed_message.g.dart';

@JsonSerializable(nullable: false)
class FeedMessage {
  final String identifier;
  final String description;

  FeedMessage({this.identifier, this.description});

  factory FeedMessage.fromJson(Map<String, dynamic> srcJson) =>
      _$FeedMessageFromJson(srcJson);
  Map<String, dynamic> toJson() => _$FeedMessageToJson(this);
}
