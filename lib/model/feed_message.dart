import 'package:json_annotation/json_annotation.dart';

part 'feed_message.g.dart';

@JsonSerializable()
class FeedMessage {
  final String identifier;
  final String organization;
  final String headline;
  final String description;
  final String ars;
  final String category;
  final DateTime publishedAt;

  FeedMessage({
    required this.identifier,
    required this.organization,
    required this.headline,
    required this.description,
    required this.ars,
    required this.category,
    required this.publishedAt,
  });

  factory FeedMessage.fromJson(Map<String, dynamic> srcJson) =>
      _$FeedMessageFromJson(srcJson);
  Map<String, dynamic> toJson() => _$FeedMessageToJson(this);
}
