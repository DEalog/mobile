import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile/api/model/region_hierarchy.dart';
import 'package:mobile/api/model/regions.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/main.dart';
import 'package:mobile/model/region.dart';

import 'model/messages.dart';

class DataService {
  final RestClient _restClient = getIt<RestClient>();

  Future<Messages> getFeedMessages(String ars, int size, int page) async {
    String rawFeed = await _restClient.fetchMessages(ars, size, page,);
    var messages = Messages.fromJson(jsonDecode(rawFeed));
    return messages;
  }

  /// Region name must be at least 3 characters long
  Future<Regions> getRegions(String name) async {
    String rawRegionsJson = await _restClient.getRegions(name);
    var regions = Regions.fromJson(jsonDecode(rawRegionsJson));
    return regions;
  }

  /// Municipal region name must be at least 3 characters long
  FutureOr<Iterable<dynamic>> getMunicipalRegions(String name) async {
    if (name.length < 3) {
      return List.empty();
    }

    String rawRegionsJson = await _restClient.getRegionsByType(
      name,
      [
        describeEnum(RegionLevel.MUNICIPALITY),
      ],
    );
    var regions = Regions.fromJson(jsonDecode(rawRegionsJson)).regions;
    return regions!;
  }

  /// Municipal region name must be at least 3 characters long
  Future<Region> getMunicipalRegion(String name) async {
    List<Region> regions = await (getMunicipalRegions(name) as FutureOr<List<Region>>);
    return regions.firstWhere(
      (region) => region.name == name,
      orElse: () => Region.empty(),
    );
  }

  Future<RegionHierarchy> getRegionHierarchy(ChannelLocation? location) async {
    var regionHierarchyJson = (ChannelLocation? location) {
      if (location != null && location.region.ars.isNotEmpty) {
        return _restClient.getRegionHierarchyById(
          location.region.ars,
        );
      }
      return _restClient.getRegionHierarchyByCoordinates(
        location!.coordinate.latitude,
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
