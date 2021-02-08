import 'package:http/http.dart' as http;

class RestClient {
  final authority = "api.dev.dealog.de";

  final List<String> dummyMessages = [
    '{ "identifier": "Warntag", "description": "oh ... jetzt schon." }',
    '{ "identifier": "WirVsVirus Finale", "description": "Danke an alle Beteiligten. Spitzen Leistung" }'
  ];

  Future<List<String>> fetchRawFeed() async {
    final List<String> rawFeed = [];

    return rawFeed == [] ? rawFeed : dummyMessages;
  }

  Future<String> getRegions(String regionName) async {
    var queryParameters = {
      "name": regionName,
    };
    var uri = Uri.https(authority, "/api/regions/", queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<String> getRegionsByType(
      String regionName, List<String> regionLevels) async {
    var queryParameters = {
      "name": regionName,
    };
    queryParameters.addEntries(
      regionLevels.map(
        (regionLevel) => MapEntry(
          "type",
          regionLevel,
        ),
      ),
    );
    var uri = Uri.https(authority, "/api/regions/", queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<String> getRegionHierarchyById(String id) async {
    var queryParameters = {
      "ars": id,
    };
    var uri = Uri.https(authority, "/api/regions/hierarchy", queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<String> getRegionHierarchyByCoordinates(
      double lat, double long) async {
    var queryParameters = {
      "long": long.toString(),
      "lat": lat.toString(),
    };
    var uri = Uri.https(authority, "/api/regions/hierarchy", queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
