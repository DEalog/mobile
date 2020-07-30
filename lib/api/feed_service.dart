import 'package:flutter/material.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/api/serializer.dart';
import 'package:provider/provider.dart';
import 'feed_message.dart';

class FeedService {
  @required
  Serializer _serializer;
  @required
  RestClient _restClient;

  FeedService(RestClient restClient, Serializer serializer) {
    _restClient = restClient;
    _serializer = serializer;
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
