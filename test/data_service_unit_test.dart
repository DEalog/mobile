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
  RestClient? restClient;
  DataService? dataService;

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

  var testMessageList = {
    "content": [
      {
        "ars": "059580004004",
        "category": "Other",
        "description":
            "In dieser Meldung wird der Ablauf für das Onboarding Schritt für Schritt erklärt.",
        "headline": "Onboarding",
        "identifier": "1f3f84e6-ae09-405b-968e-8a231a5abb70",
        "organization": "DEalog Team",
        "publishedAt": "2020-11-25T20:34:38.098+0000"
      },
      {
        "ars": "059580004004",
        "category": "Other",
        "description":
            "Facilisineglegentur appetere vix curabitur deserunt.  Explicarinoluisse integer qui sententiae metus torquent ligula dapibus.",
        "headline": "singulis omittam mei",
        "identifier": "90325ca5-5c5e-4cb3-987d-af830e13f707",
        "organization": "DEalog Team",
        "publishedAt": "2020-10-17T10:45:06.670+0000"
      },
      {
        "ars": "059580004004",
        "category": "Other",
        "description":
            "Conguelegimus ornatus euripidis scripta numquam consetetur hinc proin maluisset viris ius ridens equidem praesent elementum a porttitor class.  Omnesqueponderum civibus sadipscing donec delectus tale varius sanctus ultrices numquam disputationi eripuit appetere saepe antiopam dico.  Petentiumtellus sale dolor quo primis facilisi nulla mel dolore iuvaret fuisset verterem iriure donec errem.  Causaemel dolorem vehicula ocurreret sem.",
        "headline": "movet esse quisque laoreet",
        "identifier": "4f07dcd3-8af5-4eb5-bd44-a57c3e74fc21",
        "organization": "DEalog Team",
        "publishedAt": "2020-10-17T08:03:27.331+0000"
      },
      {
        "ars": "059580004004",
        "category": "Other",
        "description":
            "Telluspartiendo laoreet inani ad ultrices veri dicant fusce tota fugit menandri porro eu erat.  Posidoniumea consectetuer maximus parturient imperdiet iaculis sententiae voluptatum magna appetere praesent libero blandit reprehendunt mutat discere mea conubia.  Ridiculusmaximus convenire audire at persequeris vocent wisi numquam netus.  Interdumullamcorper congue ponderum.  Doloreputent error hac tristique epicuri platea fames primis posse verear discere numquam vim reprimique.  Hendreritnatum nonumy patrioque dicant noluisse mattis cum laudem instructior scripta.",
        "headline": "tibique qui eum",
        "identifier": "b2f8bac1-2842-46f1-aa56-8ff10f55b284",
        "organization": "DEalog Team",
        "publishedAt": "2020-10-17T08:03:22.331+0000"
      },
    ],
    "meta": {
      "number": 0,
      "size": 4,
      "totalElements": 1,
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
      getIt.registerSingletonAsync<RestClient>((() async => restClient!));
      getIt.registerSingletonWithDependencies(
        () => DataService(),
        dependsOn: [RestClient],
      );
      await getIt.isReady<DataService>().whenComplete(() {
        dataService = getIt<DataService>();
      });
    });

    test('fetch messages for test ars', () async {
      var testingArs = "059580004004";
      // mock raw feed
      var size = 10;
      var page = 1;

      when(restClient!.fetchMessages(testingArs, size, page)).thenAnswer(
        (_) => Future.value(
          jsonEncode(
            testMessageList,
          ),
        ),
      );

      // test getFeed
      var test = await dataService!.getFeedMessages(testingArs, size, page);

      // Get mocked Message 1 from dataService
      expect(
          test.messages![0].identifier, "1f3f84e6-ae09-405b-968e-8a231a5abb70");
      expect(test.messages![0].description,
          "In dieser Meldung wird der Ablauf für das Onboarding Schritt für Schritt erklärt.");

      // Get mocked Message 2 from dataService
      expect(
          test.messages![1].identifier, "90325ca5-5c5e-4cb3-987d-af830e13f707");
      expect(test.messages![1].description,
          "Facilisineglegentur appetere vix curabitur deserunt.  Explicarinoluisse integer qui sententiae metus torquent ligula dapibus.");

      verifyInOrder([
        restClient!.fetchMessages(testingArs, size, page),
      ]);
    });

    tearDown(() {
      getIt.reset();
    });
  });

  group('rest mock region', () {
    setUp(() async {
      restClient = MockRestClient();
      getIt.registerSingletonAsync<RestClient>((() async => restClient!));
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
      when(restClient!.getRegions(regionName)).thenAnswer(
        (_) => Future.value(
          jsonEncode(testRegionMun),
        ),
      );

      var test = await dataService!.getRegions(regionName);

      var testRegions = Regions.fromJson(testRegionMun);
      var testRegion1 = testRegions.regions![0];
      var testRegion2 = testRegions.regions![1];

      // Get mocked region 1 from dataService
      expect(test.regions![0].ars, testRegion1.ars);
      expect(test.regions![0].name, testRegion1.name);
      expect(test.regions![0].type, testRegion1.type);

      // Get mocked region 2 from dataService
      expect(test.regions![1].ars, testRegion2.ars);
      expect(test.regions![1].name, testRegion2.name);
      expect(test.regions![1].type, testRegion2.type);

      verifyInOrder([
        restClient!.getRegions,
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

      var test = await dataService!.getRegions(regionName);

      // Get mocked region 1 from dataService
      expect(test.regions!.contains(starnbergRegion), true);

      verifyInOrder([
        restClient!.getRegions,
      ]);
    });

    tearDown(() {
      getIt.reset();
    });
  });

  group('rest mock region hierarchy', () {
    setUp(() async {
      restClient = MockRestClient();
      getIt.registerSingletonAsync<RestClient>((() async => restClient!));
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
      when(restClient!.getRegionHierarchyById(location.region!.ars)).thenAnswer(
        (_) => Future.value(jsonEncode([
          germanyRegion,
          bavariaRegion,
          upperBavariaRegion,
          starnbergDistrictRegion,
          starnbergRegion
        ])),
      );

      var testRegionHierarchy = await dataService!.getRegionHierarchy(location);

      expect(testRegionHierarchy.regionHierarchy.length, 5);
      expect(testRegionHierarchy.regionHierarchy[4], starnbergRegion);
      expect(testRegionHierarchy.regionHierarchy[0], germanyRegion);
      expect(testRegionHierarchy.regionHierarchy[1], bavariaRegion);
      expect(testRegionHierarchy.regionHierarchy[2], upperBavariaRegion);

      verifyInOrder([
        restClient!.getRegions,
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

      var testRegionHierarchy = await dataService!.getRegionHierarchy(location);

      expect(testRegionHierarchy.regionHierarchy.length, 5);
      expect(testRegionHierarchy.regionHierarchy[4], starnbergRegion);
      expect(testRegionHierarchy.regionHierarchy[0], germanyRegion);
      expect(testRegionHierarchy.regionHierarchy[1], bavariaRegion);
      expect(testRegionHierarchy.regionHierarchy[2], upperBavariaRegion);

      verifyInOrder([
        restClient!.getRegions,
      ]);
    });

    tearDown(() {
      getIt.reset();
    });
  });
}
