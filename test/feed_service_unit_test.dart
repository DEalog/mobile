import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/api/feed_message.dart';
import 'package:mobile/api/feed_service.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/api/serializer.dart';
import 'package:mockito/mockito.dart';

// Mock class
class MockRestClient extends Mock implements RestClient {}

class MockSerializer extends Mock implements Serializer {}

void main() {
  RestClient restClient;
  Serializer serializer;
  FeedService feedService;

  setUp(() {
    restClient = MockRestClient();
    serializer = MockSerializer();
    feedService = FeedService(restClient, serializer);
  });

  test(
      'Feed service is fetching raw feed and converting json to message object',
      () async {
    // Create mock object.

    // mock raw feed
    when(restClient.fetchRawFeed()).thenAnswer(
      (_) => Future.value(
        Future.value(
          ["Test1", "Test2"],
        ),
      ),
    );

    // mock serializer
    FeedMessage feedMessage1 = new FeedMessage("TestId1");
    FeedMessage feedMessage2 = new FeedMessage("TestId2");

    when(serializer.getSerializedMessage("Test1")).thenReturn(feedMessage1);
    when(serializer.getSerializedMessage("Test2")).thenReturn(feedMessage2);

    // test getFeed
    var test = await feedService.getFeed();

    expect(
      test,
      [feedMessage1, feedMessage2],
    );

    verifyInOrder([
      restClient.fetchRawFeed(),
      serializer.getSerializedMessage("Test1"),
      serializer.getSerializedMessage("Test2")
    ]);
  });
}
