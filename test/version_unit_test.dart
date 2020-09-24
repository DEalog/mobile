import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/settings.dart';
import 'package:mobile/version.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info/package_info.dart';

class MockSettings extends Mock implements AppSettings {}

class MockInfo extends Mock implements PackageInfo {}

void main() {
  AppSettings settings;
  PackageInfo info;

  setUp(() {
    settings = MockSettings();
    info = MockInfo();
  });

  test('detect first run of app', () async {
    when(settings.lastKnownVersionCode).thenReturn(0);
    when(info.version).thenReturn("1.2.3");
    when(info.buildNumber).thenReturn("1");

    final version = Version(settings, info);

    expect(version.version, "1.2.3");
    expect(version.lastKnownVersionCode, 0);
    expect(version.versionCode, 1);
    expect(version.state, VersionState.INITIAL);
  });

  test('detect app update', () async {
    when(settings.lastKnownVersionCode).thenReturn(1);
    when(info.buildNumber).thenReturn("2");

    final version = Version(settings, info);

    expect(version.versionCode, 2);
    expect(version.state, VersionState.UPDATED);
  });

  test('no app update', () async {
    when(settings.lastKnownVersionCode).thenReturn(2);
    when(info.buildNumber).thenReturn("2");

    final version = Version(settings, info);

    expect(version.versionCode, 2);
    expect(version.state, VersionState.UNCHANGED);
  });
}
