import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/model/channel.dart';

void main() {
  setUp(() {});

  test('Construct from empty JSON', () async {
    var channel = Channel.fromJson("{}");

    expect(channel.location, null);
    expect(channel.categories, List.empty());
  });

  test('Construct with category', () async {
    var channel = Channel.fromJson("{\"categories\":[\"FIRE\"]}");

    expect(channel.categories, contains(ChannelCategory.FIRE));
  });

  test('Construct with category', () async {
    var channel = Channel.fromJson("{\"location\":\"Town\"}");

    expect(channel.location.name, "Town");
    expect(channel.location.longitude, 0.0);
    expect(channel.location.latitude, 0.0);
  });
}
