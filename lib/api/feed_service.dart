import 'package:mobile/api/feed_message.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/api/serializer.dart';

class FeedService {
  Serializer _serializer;
  RestClient _restClient;
  static final FeedService _inst = FeedService._internal();
  FeedService._internal();

  factory FeedService() {
    return _inst;
  }

  void setSerializer(Serializer serializer) {
    _inst._serializer = serializer;
  }

  void setRestClient(RestClient restClient) {
    _inst._restClient = restClient;
  }

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
