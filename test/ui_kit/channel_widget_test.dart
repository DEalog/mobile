import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/ui_kit/channel.dart';

import '../test_utils.dart';

void main() {

  testWidgets("should show location icon for unset location", (WidgetTester tester) async {
    final channel = Channel(null, [ChannelCategory.FIRE]);
    
    await createWidget(tester, ChannelView(channel));
    
    expect(find.byIcon(icon))
  });
}