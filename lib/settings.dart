import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:optional/optional_internal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'model/channel.dart';

class AppSettings {
  static const LAST_KNOWN_VERSION_CODE_KEY = "last_known_version_code";
  static const LOCATIONS_KEY = "locations";

  final StreamingSharedPreferences preferences;

  final Preference<int> lastKnownVersionCodePrefs;

  final Preference<List<Channel>> channels;

  int get lastKnownVersionCode => lastKnownVersionCodePrefs.getValue();

  set lastKnownVersionCode(int current) {
    lastKnownVersionCodePrefs.setValue(current);
  }

  AppSettings(this.preferences)
      : lastKnownVersionCodePrefs =
            preferences.getInt(LAST_KNOWN_VERSION_CODE_KEY, defaultValue: 0),
        channels = preferences.getCustomValue(LOCATIONS_KEY,
            defaultValue: List.empty(), adapter: ChannelAdapter());
}

class ChannelAdapter extends PreferenceAdapter<List<Channel>> {
  @override
  List<Channel> getValue(SharedPreferences preferences, String key) {
    var stringList = preferences.getStringList(key);
    return stringList.expand((element) => _fromJson(element)).toList();
  }

  Optional<Channel> _fromJson(String json) {
    Map decoded;
    try {
      decoded = jsonDecode(json);
    } on FormatException {
      return Optional.empty();
    }

    String location = decoded['location'];
    List<dynamic> categories = decoded['categories'];
    if (categories == null) {
      categories = List.empty();
    }
    return Optional.of(Channel(
        location != null ? Location(location, 0.0, 0.0) : null,
        categories.map((e) => categoryMap[e]).toList(growable: false)));
  }

  @override
  Future<bool> setValue(
      SharedPreferences preferences, String key, List<Channel> channels) {
    return preferences.setStringList(
        key, channels.map((e) => _toJson(e)).toList());
  }

  String _toJson(Channel channel) {
    var object = {
      'location': channel.location.name,
      'categories': channel.categories.map((e) => describeEnum(e)).toList()
    };
    return jsonEncode(object);
  }
}
