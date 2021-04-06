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
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: contextSize.height * 0.01,
                        bottom: contextSize.height * 0.02,
                      ),
                      child: Text(
                        this.message.headline,
                        style: Theme.of(context).textTheme.headline6,
                      ),
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
                        flex: 10,
                      ),
                    ]),
                    preview ? Spacer() : Container(),
                    Row(
                      children: [
                        Chip(
                          padding: EdgeInsets.symmetric(
                              vertical: contextSize.height * 0.01),
                          label: Text(this.message.category),
                        ),
                        Spacer(),
                        Text(this.message.organization)
                      ],
                    ),
                    preview
                        ? Container()
                        : Text(
                            this.message.description,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // ),
      // ),
    );
  }
}
