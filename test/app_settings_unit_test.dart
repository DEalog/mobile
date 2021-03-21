import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/model/region.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/gis.dart';
import 'package:mobile/app_settings.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock class
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ChannelAdapter uut;
  late SharedPreferences prefs;
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
      jsonEncode(
        {
          "location": {
            "name": "Town",
            "region": {
              "ars": "123",
              "type": "COUNTRY",
              "name": "Germany",
            },
          },
          "levels": [],
          "regionhierarchy": [],
          "categories": [],
        },
      )
    ]);

    var result = uut.getValue(prefs, key);

    Channel channel = result[0];
    expect(channel.location!.name, "Town");
    expect(channel.location!.region!.name, "Germany");
    expect(channel.location!.region!.type, RegionLevel.COUNTRY);
  });

  test('Write channel data without location', () async {
    uut.setValue(prefs, key, [
      Channel(
        null,
        Set.of([]),
        null,
        Set.of([ChannelCategory.FIRE, ChannelCategory.MET]),
      )
    ]);

    verify(prefs.setStringList(key, [
      jsonEncode({
        "location": null,
        "levels": [],
        "regionhierarchy": null,
        "categories": ["FIRE", "MET"]
      })
    ]));
  });

  test('Write all channel data', () async {
    uut.setValue(prefs, key, [
      Channel(
          ChannelLocation(
            "Location",
            Coordinate(11.5754, 48.1374),
            Region("123", "Munich", RegionLevel.DISTRICT),
          ),
          Set.of([RegionLevel.DISTRICT]),
          List.empty(),
          Set.of([ChannelCategory.FIRE, ChannelCategory.MET]))
    ]);

    verify(prefs.setStringList(key, [
      jsonEncode(
        {
          "location": {
            "name": "Location",
            "coordinate": {
              "longitude": 11.5754,
              "latitude": 48.1374,
            },
            "region": {
              "ars": "123",
              "name": "Munich",
              "type": "DISTRICT",
            },
          },
          "levels": [
            "DISTRICT",
          ],
          "regionhierarchy": [],
          "categories": [
            "FIRE",
            "MET",
          ],
        },
      )
    ]));
  });
}
