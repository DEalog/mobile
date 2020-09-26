import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/feed_service.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/api/serializer.dart';
import 'package:mobile/main.dart';
import 'package:mockito/mockito.dart';

// Mock class
class MockRestClient extends Mock implements RestClient {}

void main() {
  RestClient restClient;
  Serializer serializer;
  FeedService feedService;
  String message1 =
      '{ "identifier": "Message Heading 1", "description": "Message Content 1" }';
  String message2 =
      '{ "identifier": "Message Heading 2", "description": "Message Content 2" }';

  setUp(() {
    restClient = MockRestClient();
    serializer = Serializer();
    getIt.registerSingleton(serializer);
    getIt.registerSingleton(restClient);
    feedService = FeedService();
    getIt.registerSingleton(feedService);
  });

  test(
      'Feed service is fetching raw feed and converting json to message object',
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
    var test = await feedService.getFeed();

    // Get mocked Message 1 from feedService
    expect(test[0].identifier, "Message Heading 1");
    expect(test[0].description, "Message Content 1");

    // Get mocked Message 2 from feedService
    expect(test[1].identifier, "Message Heading 2");
    expect(test[1].description, "Message Content 2");

    verifyInOrder([
      restClient.fetchRawFeed(),
      serializer.getSerializedMessage(message1),
      serializer.getSerializedMessage(message2)
    ]);
  });
}
