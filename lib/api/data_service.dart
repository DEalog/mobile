import 'dart:convert';

import 'package:fimber/fimber_base.dart';
import 'package:mobile/api/model/region_hierarchy.dart';
import 'package:mobile/api/model/regions.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/feed_message.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/main.dart';

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

  Future<RegionHierarchy> getRegionHierarchy(Location location) async {
    var regionHierarchyJson = (Location location) {
      if (location.region != null && location.region.ars.isNotEmpty) {
        return _restClient.getRegionHierarchyById(
          location.region.ars,
        );
      }
      return _restClient.getRegionHierarchyByCoordinates(
        location.coordinate.latitude,
        location.coordinate.longitude,
      );
    };
    var rawJson = await regionHierarchyJson(location);
    var hierarchyMap = {
      "regionHierarchy": jsonDecode(rawJson),
    };
    return RegionHierarchy.fromJson(hierarchyMap);
  }
}
