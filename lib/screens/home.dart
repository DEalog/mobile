import 'package:flutter/material.dart';
import 'package:mobile/api/feed_message.dart';
import 'package:mobile/api/feed_service.dart';

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
      child: FutureBuilder<List<FeedMessage>>(
        future: futureFeedMessages,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("Snapshot has Data");
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      thickness: 0,
                    ),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var entry = snapshot.data[index];

                  print("Listet message: $index");
                  Key messageKey = Key("Message");
                  return Container(
                    key: messageKey,
                    child: Center(
                      child: Column(
                        children: [
                          Text(entry.identifier),
                          Text(entry.description)
                        ],
                      ),
                    ),
                  );
                });
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
    );
  }
}
