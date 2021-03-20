import 'dart:collection';
import 'package:fimber/fimber.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobile/api/data_service.dart';
import 'package:mobile/generated/locale_keys.g.dart';
import 'package:mobile/main.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/feed_message.dart';
import 'package:mobile/app_settings.dart';
import 'package:mobile/ui_kit/channel.dart';
import 'package:mobile/ui_kit/message_card_ui.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MessagesScreen extends StatefulWidget {
  MessagesScreen({Key key}) : super(key: key);

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  DataService dataService;
  Preference<List<Channel>> channelsPref;
  List<Channel> channels = List.empty();
  static const _pageSize = 10;

  HashMap<Channel, PagingController<int, FeedMessage>> _pagingControllers =
      HashMap();

  MessagesScreenState() {
    dataService = getIt<DataService>();
    channelsPref = getIt<AppSettings>().channels;
    // channels = channelsPref.getValue();
    // channels.forEach((channel) =>
    //     _pagingControllers[channel] = PagingController(firstPageKey: 0));
  }

  @override
  void initState() {
    // if (mounted) {
    //   setState(() {
    //     channels.forEach(
    //       (channel) => _pagingControllers[channel].addPageRequestListener(
    //         (pageKey) {
    //           _fetchFeedMessagePage(channel, pageKey);
    //         },
    //       ),
    //     );
    //   });
    // }

    channelsPref.listen(
      (newChannels) {
        if (mounted) {
          var channelsToBeDisposed = this.channels.where(
                (channel) => !newChannels.contains(channel),
              );
          var channelsToBeAdded =
              newChannels.where((newChannel) => !channels.contains(newChannel));

          setState(
            () {
              // channelsToBeDisposed.forEach((element) {
              //   this.channels.remove(element);
              // });
              //  channelsToBeAdded.forEach(
              // (newChannel) {
              //   _pagingControllers[newChannel] =
              //       PagingController(firstPageKey: 0);});

              channelsToBeAdded.forEach(
                (newChannel) {
                  _pagingControllers[newChannel] =
                      PagingController(firstPageKey: 0);

                  _pagingControllers[newChannel].addPageRequestListener(
                    (pageKey) {
                      _fetchFeedMessagePage(newChannel, pageKey);
                    },
                  );
                },
              );
              this.channels = newChannels;
            },
          );
          Future.delayed(
            Duration(milliseconds: 200),
            () => disposePagingControllers(channelsToBeDisposed),
          );
        }
      },
    );
    super.initState();
  }

  Future<void> _fetchFeedMessagePage(Channel channel, int pageKey) async {
    try {
      var ars = channel.location.coordinate == null
          ? channel.location.region.ars
          : channel.regionhierarchy.last.ars;
      final newItems =
          await dataService.getFeedMessages(ars, _pageSize, pageKey);
      final isLastPage = newItems.messages.length < _pageSize;
      if (isLastPage) {
        _pagingControllers[channel].appendLastPage(newItems.messages);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingControllers[channel].appendPage(newItems.messages, nextPageKey);
      }
    } catch (error) {
      _pagingControllers[channel].error = error;
    }
  }

  List<Widget> buildChannels() => channels.map((channel) {
        var channelIndex = channels.indexOf(channel);
        var _scrollController = new ScrollController();
        var _displacement = 40.0;
        _scrollController.addListener(() {
          if (_scrollController.offset + _displacement <
              _scrollController.position.minScrollExtent) {
            _pagingControllers[channel].refresh();
          }
        });
        return Column(
          children: [
            LocationView(
              channel.location,
              alignment: Alignment.centerLeft,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Container(
                child: PagedListView<int, FeedMessage>(
                  key: Key('PageListViewMessages_$channelIndex'),
                  scrollDirection: Axis.horizontal,
                  scrollController: _scrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  pagingController: _pagingControllers[channel],
                  builderDelegate: PagedChildBuilderDelegate<FeedMessage>(
                    itemBuilder: (context, item, index) {
                      Key messageKey = Key("Message_${channelIndex}_$index");
                      return MessageCardUi(
                        key: messageKey,
                        identifier: item.headline,
                        description: item.description,
                      );
                    },
                    noItemsFoundIndicatorBuilder: (context) => MessageCardUi(
                      key: Key("NoFeedMessagesAvailable"),
                      identifier:
                          LocaleKeys.messages_no_feed_messages_available.tr(),
                      description: '',
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }).toList(
        growable: false,
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      key: Key("HomeScreen"),
      // height: MediaQuery.of(context).size.height * 0.867,
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () {
            Fimber.d("Home - Refresh all channels called");
            _pagingControllers.forEach(
              (channel, pagingController) {
                Fimber.d(
                    "Home - Refresh individual channel ${channel.location.name}");
                pagingController.refresh();
              },
            );
          },
        ),
        child: ListView(
          children: buildChannels(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposePagingControllers(this.channels);
    super.dispose();
  }

  void disposePagingControllers(channelsToBeDispose) {
    channelsToBeDispose.forEach((channel) {
      _pagingControllers[channel].dispose();
      _pagingControllers.remove(channel);
    });
  }
}
