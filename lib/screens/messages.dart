import 'dart:collection';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/api/data_service.dart';
import 'package:mobile/main.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/feed_message.dart';
import 'package:mobile/app_settings.dart';
import 'package:mobile/ui_kit/channel.dart';
import 'package:mobile/ui_kit/message_card_ui.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MessagesScreen extends StatefulWidget {
  MessagesScreen({Key key}) : super(key: key);

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  HashMap<Channel, Future<List<FeedMessage>>> futureFeedMessages = HashMap();
  DataService dataService;
  Preference<List<Channel>> channelsPref;
  List<Channel> channels;

  MessagesScreenState() {
    dataService = getIt<DataService>();
    channelsPref = getIt<AppSettings>().channels;
    channels = channelsPref.getValue();
  }

  @override
  void initState() {
    super.initState();
    channelsPref.listen(
      (newChannels) {
        if (mounted) {
          setState(
            () {
              channels = newChannels;
              channels.forEach(
                (channel) {
                  futureFeedMessages[channel] = dataService.getFeed();
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> channelBoxes = channels.map((channel) {
      return FutureBuilder(
        future: futureFeedMessages[channel],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Fimber.d("Snapshot has Data");
            return Column(
              children: [
                LocationView(
                  channel.location,
                  alignment: Alignment.centerLeft,
                ),
                Container(
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
                        Key messageKey = Key("Message");
                        return MessageCardUi(
                          key: messageKey,
                          identifier: entry.identifier,
                          description: entry.description,
                        );
                      }),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            Fimber.d("Home - Snapshot has error");
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return PlatformCircularProgressIndicator(
            key: Key("CircularProgressIndicator"),
          );
        },
      );
    }).toList();
    List<Widget> homeWidgets = [];
    homeWidgets.addAll(channelBoxes);

    return Expanded(
      key: Key("HomeScreen"),
      // height: MediaQuery.of(context).size.height * 0.867,
      child: ListView(
        children: homeWidgets,
      ),
    );
  }
}
