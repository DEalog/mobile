import 'package:fimber/fimber.dart';
import 'package:mobile/settings.dart';
import 'package:package_info/package_info.dart';

class Version {
  final AppSettings settings;
  final PackageInfo info;
  String _version;
  int _versionCode;
  int _lastKnownVersionCode;
  VersionState _state = VersionState.UNCHANGED;

  String get version => _version;

  int get versionCode => _versionCode;

  int get lastKnownVersionCode => _lastKnownVersionCode;

  VersionState get state => _state;

  Version(AppSettings settings, PackageInfo info)
      : settings = settings,
        info = info {
    _version = info.version;
    _versionCode = int.parse(info.buildNumber);
    _lastKnownVersionCode = settings.lastKnownVersionCode;

    settings.lastKnownVersionCode = versionCode;

    if (lastKnownVersionCode == 0) {
      _state = VersionState.INITIAL;
    } else if (lastKnownVersionCode != versionCode) {
      _state = VersionState.UPDATED;
    } else {
      _state = VersionState.UNCHANGED;
    }
    Fimber.i(
        "Version '$version' ($lastKnownVersionCode) -> ($versionCode) = ${state.toString()}");
  }
}

enum VersionState { INITIAL, UPDATED, UNCHANGED }
