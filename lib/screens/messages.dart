import 'dart:collection';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/api/data_service.dart';
import 'package:mobile/generated/locale_keys.g.dart';
import 'package:mobile/main.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/feed_message.dart';
import 'package:mobile/app_settings.dart';
import 'package:mobile/ui_kit/channel.dart';
import 'package:mobile/ui_kit/message_detail.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MessagesScreen extends StatefulWidget {
  MessagesScreen({Key? key}) : super(key: key);

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

  MessagesScreenState()
      : dataService = getIt<DataService>(),
        channelsPref = getIt<AppSettings>().channels;

  @override
  void initState() {
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
              channelsToBeAdded.forEach(
                (newChannel) {
                  _pagingControllers[newChannel] =
                      PagingController(firstPageKey: 0);

                  _pagingControllers[newChannel]!.addPageRequestListener(
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
      var ars = channel.location.coordinate.isValid
          ? channel.regionhierarchy.last.ars
          : channel.location.region.ars;
      final newItems =
          await dataService.getFeedMessages(ars, _pageSize, pageKey);
      final isLastPage = newItems.messages!.length < _pageSize;
      if (isLastPage) {
        _pagingControllers[channel]!.appendLastPage(newItems.messages!);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingControllers[channel]!
            .appendPage(newItems.messages!, nextPageKey);
      }
    } catch (error) {
      _pagingControllers[channel]!.error = error;
    }
  }

  List<StatelessWidget> buildChannels(BuildContext context) => channels.map((channel) {
        var contextSize = MediaQuery.of(context).size;
        var channelIndex = channels.indexOf(channel);
        var _scrollController = new ScrollController();
        var _displacement = 40.0;
        _scrollController.addListener(() {
          if (_scrollController.offset + _displacement <
              _scrollController.position.minScrollExtent) {
            _pagingControllers[channel]!.refresh();
          }
        });
        return [
            LocationView(
              channel.location,
              alignment: Alignment.centerLeft,
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: contextSize.height * 0.02,
              ),
              height: contextSize.height * 0.28,
              child: PagedListView<int, FeedMessage>(
                key: Key('PageListViewMessages_$channelIndex'),
                scrollDirection: Axis.horizontal,
                scrollController: _scrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                pagingController: _pagingControllers[channel]!,
                builderDelegate: PagedChildBuilderDelegate<FeedMessage>(
                  itemBuilder: (context, item, index) {
                    String messageDetailTag =
                        'MessageDetailHero_${channelIndex}_$index';
                    String messageDetailKey = "Message_${channelIndex}_$index";
                    return MessageDetail(
                      key: Key(messageDetailKey),
                      message: item,
                      preview: true,
                      tag: messageDetailTag,
                      width: contextSize.width * 0.8,
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          barrierColor: Colors.white,
                          fullscreenDialog: true,
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => PlatformScaffold(
                            material: (context, platform) =>
                                MaterialScaffoldData(
                                    resizeToAvoidBottomInset: false),
                            cupertino: (context, platform) =>
                                CupertinoPageScaffoldData(
                              resizeToAvoidBottomInset: false,
                            ),
                            iosContentPadding: true,
                            backgroundColor: Colors.transparent,
                            body: SafeArea(
                              child: MessageDetail(
                                key: Key('{$messageDetailKey}_Fullscreen'),
                                tag: messageDetailTag,
                                message: item,
                                onTap: () => Navigator.pop(context),
                                preview: false,
                                width: contextSize.width,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  noItemsFoundIndicatorBuilder: (context) => MessageDetail(
                    key: Key("NoFeedMessagesAvailable"),
                    message: FeedMessage(
                      headline:
                          LocaleKeys.messages_no_feed_messages_available.tr(),
                      description: '',
                      ars: '',
                      category: '',
                      identifier: '',
                      organization: '',
                      publishedAt: DateTime.now(),
                    ),
                    onTap: () {},
                    preview: true,
                    tag: '',
                    width: contextSize.width,
                  ),
                ),
              ),
            ),
          ];
        
      }).expand((e) => e).toList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      key: Key("HomeScreen"),
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
          children: buildChannels(context),
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
      _pagingControllers[channel]!.dispose();
      _pagingControllers.remove(channel);
    });
  }
}
