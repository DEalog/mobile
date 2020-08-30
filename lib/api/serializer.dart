import 'dart:convert';
import 'package:mobile/api/feed_message.dart';

class Serializer {
  FeedMessage getSerializedMessage(String jsonString) {
    Map feedMessageMap = jsonDecode(jsonString);
    return FeedMessage.fromJson(feedMessageMap);
  }
}
