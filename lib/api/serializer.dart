import 'feed_message.dart';

class Serializer {
  FeedMessage getSerializedMessage(String json) {
    return FeedMessage(json);
  }
}
