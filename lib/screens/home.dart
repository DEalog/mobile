import 'dart:collection';

import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:mobile/api/feed_service.dart';
import 'package:mobile/main.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/feed_message.dart';
import 'package:mobile/settings.dart';
import 'package:mobile/ui_kit/channel.dart';
import 'package:mobile/ui_kit/message_card_ui.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  HashMap<Channel, Future<List<FeedMessage>>> futureFeedMessages = HashMap();
  FeedService feedService;
  Preference<List<Channel>> channelsPref;
  List<Channel> channels = List();

  HomeScreenState() {
    feedService = getIt<FeedService>();
    channelsPref = getIt<AppSettings>().channels;
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
                  futureFeedMessages[channel] = feedService.getFeed();
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
                ChannelView(channel),
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
          return CircularProgressIndicator(
            key: Key("CircularProgressIndicator"),
          );
        },
      );
    }).toList();
    List<Widget> homeWidgets = [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
        child: Image.asset(
          'assets/images/dealog_logo.png',
          key: Key('DEalogLogoKey'),
          semanticLabel: 'DEalog Logo',
          height: MediaQuery.of(context).size.height * 0.08,
        ),
      ),
    ];
    homeWidgets.addAll(channelBoxes);

    return Container(
      key: Key("HomeScreen"),
      child: Column(
        children: homeWidgets,
      ),
    );
  }
}
