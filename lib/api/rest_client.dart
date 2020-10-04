class RestClient {
  final List<String> dummyMessages = [
    '{ "identifier": "Warntag", "description": "oh ... jetzt schon." }',
    '{ "identifier": "WirVsVirus Finale", "description": "Danke an alle Beteiligten. Spitzen Leistung" }'
  ];

  Future<List<String>> fetchRawFeed() async {
    final List<String> rawFeed = [];

    return rawFeed == [] ? rawFeed : dummyMessages;
  }
}
