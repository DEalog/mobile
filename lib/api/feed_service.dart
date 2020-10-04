import 'package:mobile/model/feed_message.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/api/serializer.dart';
import 'package:mobile/main.dart';

class FeedService {
  Serializer _serializer = getIt<Serializer>();
  RestClient _restClient = getIt<RestClient>();

  Future<List<FeedMessage>> getFeed() async {
    List<String> rawFeed = await _restClient.fetchRawFeed();
    List<FeedMessage> serializedMessagesFromFeed = rawFeed.map(
      (rawFeedMessageString) {
        FeedMessage message =
            _serializer.getSerializedMessage(rawFeedMessageString);
        return message;
      },
    ).toList();
    return serializedMessagesFromFeed;
  }
}
