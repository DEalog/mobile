import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/model/channel.dart';

void main() {
  setUp(() {});

  test('Construct from empty JSON', () async {
    var channel = Channel.fromJson("{}");

    expect(channel.isPresent, true);
    expect(channel.value.location, null);
    expect(channel.value.categories, List.empty());
  });

  test('Construct from invalid JSON', () async {
    var channel = Channel.fromJson("bad");

    expect(channel.isPresent, false);
  });

  test('Construct with category', () async {
    var channel = Channel.fromJson("{\"categories\":[\"FIRE\"]}");

    expect(channel.value.categories, contains(ChannelCategory.FIRE));
  });

  test('Construct with category', () async {
    var channel = Channel.fromJson("{\"location\":\"Town\"}");

    expect(channel.value.location.name, "Town");
    expect(channel.value.location.longitude, 0.0);
    expect(channel.value.location.latitude, 0.0);
  });
}
