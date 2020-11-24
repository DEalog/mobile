import 'dart:convert';

import 'package:mobile/api/model/regions.dart';
import 'package:mobile/model/feed_message.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/main.dart';
import 'package:mobile/model/region.dart';

class DataService {
  final RestClient _restClient = getIt<RestClient>();

  Future<List<FeedMessage>> getFeed() async {
    List<String> rawFeed = await _restClient.fetchRawFeed();
    List<FeedMessage> serializedMessagesFromFeed = rawFeed
        .map(
          (rawFeedMessageString) => FeedMessage.fromJson(
            jsonDecode(rawFeedMessageString),
          ),
        )
        .toList();
    return serializedMessagesFromFeed;
  }

  Future<Regions> getRegions(String name) async {
    String rawRegionsJson = await _restClient.getRegions(name);
    var regions = Regions.fromJson(jsonDecode(rawRegionsJson));
    return regions;
  }
}
