import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/api/data_service.dart';
import 'package:mobile/api/model/regions.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/region.dart';
import 'package:mockito/mockito.dart';

// Mock class
class MockRestClient extends Mock implements RestClient {}

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

void main() {
  RestClient restClient;
  DataService dataService;
  String message1 =
      '{ "identifier": "Message Heading 1", "description": "Message Content 1" }';
  String message2 =
      '{ "identifier": "Message Heading 2", "description": "Message Content 2" }';
  var testRegionMun = {
    "content": [
      {
        "ars": "123",
        "name": "Munich",
        "type": "MUNICIPALITY",
      },
      {
        "ars": "124",
        "name": "Munich Ost",
        "type": "MUNICIPALITY",
      },
    ],
    "meta": {
      "size": 10,
      "number": 0,
      "totalElements": 9,
      "totalPages": 1,
    }
  };

  var starnbergRegion = Region(
    "091880139139",
    "Starnberg",
    RegionLevel.MUNICIPALITY,
  );

  var starnbergDistrictRegion = Region(
    "09188",
    "Starnberg",
    RegionLevel.DISTRICT,
  );

  var germanyRegion = Region(
    "000000000000",
    "Deutschland",
    RegionLevel.COUNTRY,
  );

  var bavariaRegion = Region(
    "09",
    "Bayern (Bodensee)",
    RegionLevel.STATE,
  );

  var upperBavariaRegion = Region(
    "091",
    "Oberbayern",
    RegionLevel.COUNTY,
  );

  group('rest mock message service', () {
    setUp(() async {
      restClient = MockRestClient();
      getIt.registerSingletonAsync<RestClient>(() async => restClient);
      getIt.registerSingletonWithDependencies(
        () => DataService(),
        dependsOn: [RestClient],
      );
      await getIt.isReady<DataService>().whenComplete(() {
        dataService = getIt<DataService>();
      });
    });

    test(
        'data service is fetching raw feed and converting json to message object',
        () async {
      // Create mock object.

      // mock raw feed
      when(restClient.fetchRawFeed()).thenAnswer(
        (_) => Future.value(
          Future.value(
            [
              message1,
              message2,
            ],
          ),
        ),
      );

      // test getFeed
      var test = await dataService.getFeed();

      // Get mocked Message 1 from dataService
      expect(test[0].identifier, "Message Heading 1");
      expect(test[0].description, "Message Content 1");

      // Get mocked Message 2 from dataService
      expect(test[1].identifier, "Message Heading 2");
      expect(test[1].description, "Message Content 2");

      verifyInOrder([
        restClient.fetchRawFeed(),
      ]);
    });

    tearDown(() {
      getIt.reset();
    });
  });

  group('rest mock region', () {
    setUp(() async {
      restClient = MockRestClient();
      getIt.registerSingletonAsync<RestClient>(() async => restClient);
      getIt.registerSingletonWithDependencies(
        () => DataService(),
        dependsOn: [RestClient],
      );
      await getIt.isReady<DataService>().whenComplete(() {
        dataService = getIt<DataService>();
      });
    });

    test('Request ars Mun with two regions in response', () async {
      var regionName = "Mun";
      // mock raw feed
      when(restClient.getRegions(regionName)).thenAnswer(
        (_) => Future.value(
          jsonEncode(testRegionMun),
        ),
      );

      var test = await dataService.getRegions(regionName);

      var testRegions = Regions.fromJson(testRegionMun);
      var testRegion1 = testRegions.regions[0];
      var testRegion2 = testRegions.regions[1];

      // Get mocked region 1 from dataService
      expect(test.regions[0].ars, testRegion1.ars);
      expect(test.regions[0].name, testRegion1.name);
      expect(test.regions[0].type, testRegion1.type);

      // Get mocked region 2 from dataService
      expect(test.regions[1].ars, testRegion2.ars);
      expect(test.regions[1].name, testRegion2.name);
      expect(test.regions[1].type, testRegion2.type);

      verifyInOrder([
        restClient.getRegions,
      ]);
    });

    tearDown(() {
      getIt.reset();
    });
  });

  group('rest region', () {
    setUp(() async {
      getIt.registerSingletonAsync<RestClient>(() async => RestClient());
      getIt.registerSingletonWithDependencies(
        () => DataService(),
        dependsOn: [RestClient],
      );
      await getIt.isReady<DataService>().whenComplete(() {
        dataService = getIt<DataService>();
      });
    });

    test('Request ars Starnberg', () async {
      var regionName = starnbergRegion.name;

      var test = await dataService.getRegions(regionName);

      // Get mocked region 1 from dataService
      expect(test.regions.contains(starnbergRegion), true);

      verifyInOrder([
        restClient.getRegions,
      ]);
    });

    tearDown(() {
      getIt.reset();
    });
  });

  group('rest mock region hierarchy', () {
    setUp(() async {
      restClient = MockRestClient();
      getIt.registerSingletonAsync<RestClient>(() async => restClient);
      getIt.registerSingletonWithDependencies(
        () => DataService(),
        dependsOn: [RestClient],
      );
      await getIt.isReady<DataService>().whenComplete(() {
        dataService = getIt<DataService>();
      });
    });

    test('Request hierarchy by ARS for starnberg', () async {
      var location = ChannelLocation(
        "Starnberg",
        null,
        starnbergRegion,
      );

      // mock raw feed
      when(restClient.getRegionHierarchyById(location.region.ars)).thenAnswer(
        (_) => Future.value(jsonEncode([
          germanyRegion,
          bavariaRegion,
          upperBavariaRegion,
          starnbergDistrictRegion,
          starnbergRegion
        ])),
      );

      var testRegionHierarchy = await dataService.getRegionHierarchy(location);

      expect(testRegionHierarchy.regionHierarchy.length, 5);
      expect(testRegionHierarchy.regionHierarchy[4], starnbergRegion);
      expect(testRegionHierarchy.regionHierarchy[0], germanyRegion);
      expect(testRegionHierarchy.regionHierarchy[1], bavariaRegion);
      expect(testRegionHierarchy.regionHierarchy[2], upperBavariaRegion);

      verifyInOrder([
        restClient.getRegions,
      ]);
    });

    tearDown(() {
      getIt.reset();
    });
  });

  group('rest region', () {
    setUp(() async {
      getIt.registerSingletonAsync<RestClient>(() async => RestClient());
      getIt.registerSingletonWithDependencies(
        () => DataService(),
        dependsOn: [RestClient],
      );
      await getIt.isReady<DataService>().whenComplete(() {
        dataService = getIt<DataService>();
      });
    });

    test('Request hierarchy by ARS for starnberg', () async {
      var location = ChannelLocation(
        "Starnberg",
        null,
        starnbergRegion,
      );

      var testRegionHierarchy = await dataService.getRegionHierarchy(location);

      expect(testRegionHierarchy.regionHierarchy.length, 5);
      expect(testRegionHierarchy.regionHierarchy[4], starnbergRegion);
      expect(testRegionHierarchy.regionHierarchy[0], germanyRegion);
      expect(testRegionHierarchy.regionHierarchy[1], bavariaRegion);
      expect(testRegionHierarchy.regionHierarchy[2], upperBavariaRegion);

      verifyInOrder([
        restClient.getRegions,
      ]);
    });

    tearDown(() {
      getIt.reset();
    });
  });
}
