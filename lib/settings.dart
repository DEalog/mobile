import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AppSettings {
  static const LAST_KNOWN_VERSION_CODE_KEY = "last_known_version_code";
  static const LOCATIONS_KEY = "locations";

  final StreamingSharedPreferences preferences;

  final Preference<int> lastKnownVersionCodePrefs;
  final Preference<List<String>> locations;

  int get lastKnownVersionCode => lastKnownVersionCodePrefs.getValue();

  set lastKnownVersionCode(int current) {
    lastKnownVersionCodePrefs.setValue(current);
  }

  AppSettings(this.preferences)
      : lastKnownVersionCodePrefs =
            preferences.getInt(LAST_KNOWN_VERSION_CODE_KEY, defaultValue: 0),
        locations = preferences.getStringList(LOCATIONS_KEY,
            defaultValue: List.empty());
}
