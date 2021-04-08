import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/model/gis.dart';
import 'package:mobile/model/region.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/app_settings.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_settings_unit_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  ChannelAdapter uut = ChannelAdapter();
  SharedPreferences prefs = MockSharedPreferences();
  final String key = "<key>";

  setUp(() {});

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
    when(prefs.getStringList(key)).thenReturn(
      [
        jsonEncode(
          {
            "location": ChannelLocation.empty(),
            "levels": [],
            "regionhierarchy": [],
            "categories": ["FIRE"],
          },
        ),
      ],
    );

    var result = uut.getValue(prefs, key);

    Channel channel = result[0];
    expect(channel.categories, contains(ChannelCategory.FIRE));
  });

  test('Read channel with location name only', () async {
    when(prefs.getStringList(key)).thenReturn(
      [
        jsonEncode(
          {
            "location": ChannelLocation(
              "Town",
              Coordinate.invalid(),
              Region(
                "123",
                "Germany",
                RegionLevel.COUNTRY,
              ),
            ).toJson(),
            "levels": [],
            "regionhierarchy": [],
            "categories": [],
          },
        )
      ],
    );

    var result = uut.getValue(prefs, key);

    Channel channel = result[0];
    expect(channel.location.name, "Town");
    expect(channel.location.region.name, "Germany");
    expect(channel.location.region.type, RegionLevel.COUNTRY);
  });

  test('Write channel data without location', () async {
    var stringListToBeTested = [
      jsonEncode({
        "location": ChannelLocation.empty().toJson(),
        "levels": [],
        "regionhierarchy": [],
        "categories": ["FIRE", "MET"]
      })
    ];
    when(
      prefs.setStringList(key, stringListToBeTested),
    ).thenAnswer(
      (_) => Future.value(
        true,
      ),
    );
    var retVal = await uut.setValue(prefs, key, [
      Channel(
        ChannelLocation.empty(),
        Set.of([]),
        [],
        Set.of([ChannelCategory.FIRE, ChannelCategory.MET]),
      )
    ]);

    expect(retVal, true);

    verify(prefs.setStringList(
      key,
      stringListToBeTested,
    ));
  });

  test('Write all channel data', () async {
    var stringListToBeTested = [
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
    ];
    when(
      prefs.setStringList(key, stringListToBeTested),
    ).thenAnswer(
      (_) => Future.value(
        true,
      ),
    );
    uut.setValue(
      prefs,
      key,
      [
        Channel(
          ChannelLocation(
            "Location",
            Coordinate(11.5754, 48.1374),
            Region(
              "123",
              "Munich",
              RegionLevel.DISTRICT,
            ),
          ),
          Set.of([RegionLevel.DISTRICT]),
          List.empty(),
          Set.of([
            ChannelCategory.FIRE,
            ChannelCategory.MET,
          ]),
        ),
      ],
    );

    verify(prefs.setStringList(key, stringListToBeTested));
  });
}
