import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/api/feed_message.dart';
import 'package:mobile/api/feed_service.dart';
import 'package:mobile/ui_kit/message_card_ui.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Future<List<FeedMessage>> futureFeedMessages;
  FeedService feedService = FeedService();

  @override
  void initState() {
    super.initState();
    futureFeedMessages = feedService.getFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: Key("HomeScreen"),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/dealog_logo.svg',
              key: Key('DEalogLogoKey'),
              semanticsLabel: 'DEalog Logo',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            FutureBuilder<List<FeedMessage>>(
              future: futureFeedMessages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("Snapshot has Data");
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              thickness: 0,
                            ),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var entry = snapshot.data[index];

                          print("Listet message: $index");
                          Key messageKey = Key("Message");
                          return MessageCardUi(
                            key: messageKey,
                            identifier: entry.identifier,
                            description: entry.description,
                          );
                        }),
                  );
                } else if (snapshot.hasError) {
                  print("Snapshot has error");
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator(
                  key: Key("CircularProgressIndicator"),
                );
              },
            ),
          ],
        ));
  }
}
