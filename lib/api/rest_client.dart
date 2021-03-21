import 'dart:convert';

import 'package:http/http.dart' as http;

class RestClient {
  final authority = "api.dev.dealog.de";
  final encoding = "utf-8";

  final List<String> dummyMessages = [
    '{ "identifier": "Warntag", "description": "oh ... jetzt schon." }',
    '{ "identifier": "WirVsVirus Finale", "description": "Danke an alle Beteiligten. Spitzen Leistung" }'
  ];

  Future<String> getRegions(String? regionName) async {
    var queryParameters = {
      "charset": encoding,
      "name": regionName,
    };
    var uri = Uri.https(authority, "/api/regions/", queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return utf8.decode(response.bodyBytes);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<String> getRegionsByType(
      String regionName, List<String> regionLevels) async {
    var queryParameters = {
      "charset": encoding,
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
      return utf8.decode(response.bodyBytes);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<String> getRegionHierarchyById(String? id) async {
    var queryParameters = {
      "ars": id,
      "charset": encoding,
    };
    var uri = Uri.https(authority, "/api/regions/hierarchy", queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return utf8.decode(response.bodyBytes);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<String> getRegionHierarchyByCoordinates(
      double? lat, double? long) async {
    var queryParameters = {
      "long": long.toString(),
      "lat": lat.toString(),
      "charset": encoding,
    };
    var uri = Uri.https(authority, "/api/regions/hierarchy", queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return utf8.decode(response.bodyBytes);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<String> fetchMessages(String? ars, int size, int page) async {
    var queryParameters = {
      "page": page.toString(),
      "size": size.toString(),
      "ars": ars,
      "charset": encoding,
    };
    var uri = Uri.https(authority, "/api/messages", queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return utf8.decode(response.bodyBytes);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
