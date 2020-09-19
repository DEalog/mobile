class RestClient {
  final String message1 =
      '{ "identifier": "Message Heading 1", "description": "Message Content 1" }';
  final String message2 =
      '{ "identifier": "Message Heading 2", "description": "Message Content 2" }';
  Future<List<String>> fetchRawFeed() async {
    // return new List<String>();
    return [message1, message2];
  }
}
