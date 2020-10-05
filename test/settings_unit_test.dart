import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/settings.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock class
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  ChannelAdapter uut;
  SharedPreferences prefs;
  final String key = "<key>";

  setUp(() {
    uut = ChannelAdapter();
    prefs = MockSharedPreferences();
  });

  test('Reads empty JSON', () async {
    when(prefs.getStringList(key)).thenReturn(List.of(["{}"]));

    var result = uut.getValue(prefs, key);

    expect(result, List.empty());
  });

  test('Read ingores channel with invalid JSON', () async {
    when(prefs.getStringList(key)).thenReturn(List.of(["bad"]));

    var result = uut.getValue(prefs, key);

    expect(result, List.empty());
  });

  test('Read channel with single category', () async {
    when(prefs.getStringList(key))
        .thenReturn(List.of(["{\"categories\":[\"FIRE\"]}"]));

    var result = uut.getValue(prefs, key);

    Channel channel = result[0];
    expect(channel.categories, contains(ChannelCategory.FIRE));
  });

  test('Read channel with location name only', () async {
    when(prefs.getStringList(key)).thenReturn([
      "{\"location\":{\"name\":\"Town\",\"longitude\":0.0,\"latitude\":0.0},\"categories\":[]}"
    ]);

    var result = uut.getValue(prefs, key);

    Channel channel = result[0];
    expect(channel.location.name, "Town");
    expect(channel.location.longitude, 0.0);
    expect(channel.location.latitude, 0.0);
  });

  test('Write channel data without location', () async {
    uut.setValue(prefs, key, [
      Channel(null, Set.of([ChannelCategory.FIRE, ChannelCategory.MET]))
    ]);

    verify(prefs.setStringList(
        key, ["{\"location\":null,\"categories\":[\"FIRE\",\"MET\"]}"]));
  });

  test('Write all channel data', () async {
    uut.setValue(prefs, key, [
      Channel(Location("Location", 1.0, 2.0),
          Set.of([ChannelCategory.FIRE, ChannelCategory.MET]))
    ]);

    verify(prefs.setStringList(key, [
      "{\"location\":{\"longitude\":1.0,\"latitude\":2.0,\"name\":\"Location\"},\"categories\":[\"FIRE\",\"MET\"]}"
    ]));
  });
}
