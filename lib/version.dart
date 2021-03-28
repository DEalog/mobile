import 'package:fimber/fimber.dart';
import 'package:mobile/app_settings.dart';
import 'package:package_info/package_info.dart';

class Version {
  final AppSettings settings;
  final PackageInfo info;
  String _version;
  int _versionCode;
  VersionState _state = VersionState.UNCHANGED;

  String get version => _version;

  int get versionCode => _versionCode;

  int get lastKnownVersionCode => settings.lastKnownVersionCode;

  bool get isInitialVersion => state == VersionState.INITIAL;

  VersionState get state => _state;

  void updateVersionState() {
    if (lastKnownVersionCode == 0) {
      _state = VersionState.INITIAL;
    } else if (lastKnownVersionCode != versionCode) {
      _state = VersionState.UPDATED;
    } else {
      _state = VersionState.UNCHANGED;
    }
  }

  Version(AppSettings settings, PackageInfo info)
      : settings = settings,
        info = info,
        _version = info.version,
        _versionCode = int.parse(info.buildNumber) {
    updateVersionState();
    settings.lastKnownVersionCode = versionCode;

    Fimber.i(
        "Version '$version' ($lastKnownVersionCode) -> ($versionCode) = ${state.toString()}");
  }
}

enum VersionState { INITIAL, UPDATED, UNCHANGED }
