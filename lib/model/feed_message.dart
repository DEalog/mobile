import 'package:json_annotation/json_annotation.dart';

part 'feed_message.g.dart';

@JsonSerializable()
class FeedMessage {
  final String? identifier;
  final String? organization;
  final String? headline;
  final String? description;
  final String? ars;
  final String? category;
  final String? publishedAt;

  FeedMessage({
    this.identifier,
    this.organization,
    this.headline,
    this.description,
    this.ars,
    this.category,
    this.publishedAt,
  });

  factory FeedMessage.fromJson(Map<String, dynamic> srcJson) =>
      _$FeedMessageFromJson(srcJson);
  Map<String, dynamic> toJson() => _$FeedMessageToJson(this);
}
