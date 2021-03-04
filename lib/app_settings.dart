import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:optional/optional.dart';
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
        channels = preferences.getCustomValue(
          LOCATIONS_KEY,
          defaultValue: List.empty(),
          adapter: ChannelAdapter(),
        );
}

class ChannelAdapter extends PreferenceAdapter<List<Channel>> {
  @override
  List<Channel> getValue(SharedPreferences preferences, String key) {
    var stringList = preferences.getStringList(key);
    if (stringList != null) {
      return stringList.expand((e) => _fromJson(e)).toList();
    } else {
      return List.empty();
    }
  }

  Optional<Channel> _fromJson(String json) {
    try {
      return Optional.of(Channel.fromJson(jsonDecode(json)));
    } catch (e) {
      Fimber.w("Could not parse JSON string $json", ex: e);
      return Optional.empty();
    }
  }

  @override
  Future<bool> setValue(
      SharedPreferences preferences, String key, List<Channel> channels) {
    var channelsJson = channels.map((channel) => _toJson(channel)).toList();
    return preferences.setStringList(key, channelsJson);
  }

  String _toJson(Channel channel) {
    return jsonEncode(channel.toJson());
  }
}
