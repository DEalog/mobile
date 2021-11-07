import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/model/feed_message.dart';

class MessageDetail extends StatelessWidget {
  final FeedMessage message;
  final String tag;
  final VoidCallback onTap;
  final double width;
  final bool preview;
  const MessageDetail({
    required Key key,
    required this.message,
    required this.tag,
    required this.onTap,
    required this.width,
    required this.preview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contextSize = MediaQuery.of(context).size;
    return SizedBox(
      width: width,
      child: Hero(
        tag: tag,
        child: Card(
          margin: EdgeInsets.all(contextSize.width * 0.015),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(contextSize.width * 0.02),
          ),
          elevation: contextSize.width * 0.011,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(contextSize.height * 0.015),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    preview
                        ? Expanded(
                            flex: 4,
                            child: Text(
                              this.message.headline,
                              overflow: TextOverflow.clip,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          )
                        : Text(
                            this.message.headline,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                    Spacer(
                      flex: preview ? 2 : 1,
                    ),
                    Row(children: [
                      Text(
                        DateFormat.yMd(
                          EasyLocalization.of(context)!
                              .currentLocale!
                              .countryCode,
                        ).format(
                          this.message.publishedAt,
                        ),
                      ),
                      Spacer(),
                      Text(
                        DateFormat.Hms(
                          EasyLocalization.of(context)!
                              .currentLocale!
                              .countryCode,
                        ).format(
                          this.message.publishedAt,
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ]),
                    Spacer(
                      flex: 1,
                    ),
                    Row(
                      children: [
                        Chip(
                          label: Text(this.message.category),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                        Spacer(),
                        Chip(
                          label: Text(this.message.organization),
                          backgroundColor: Theme.of(context).highlightColor,
                        )
                      ],
                    ),
                    preview
                        ? Container()
                        : Spacer(
                            flex: 1,
                          ),
                    preview
                        ? Container()
                        : Expanded(
                            flex: 30,
                            child: Text(
                              this.message.description,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
