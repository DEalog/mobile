import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_animator/flutter_animator.dart';

class MessageCardUi extends StatelessWidget {
  final String identifier;
  final String description;
  final double width;

  const MessageCardUi({
    Key key,
    this.identifier,
    this.description,
    this.width = -1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contextSize = MediaQuery.of(context).size;
    var _width = this.width < 0 ? contextSize.width * 0.8 : this.width;
    var _height = contextSize.height * 0.81;

    return SizedBox(
      width: _width,
      child: GestureDetector(
        onTap: () => ZoomOut(
          child: SafeArea(
            child: Container(
              width: contextSize.width,
              height: _height,
              // padding: EdgeInsets.symmetric(
              //   horizontal: contextSize.width * 0.01,
              //   vertical: contextSize.height * 0.1,
              // ),
              // constraints: BoxConstraints.,
              // height: contextSize.height * 0.7,
              decoration: new BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(contextSize.width * 0.08),
                  topRight: Radius.circular(contextSize.width * 0.08),
                ),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    this.description,
                  ),
                ],
              ),
            ),
          ),
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            leading: Icon(
              Icons.warning_amber_rounded,
              size: contextSize.height * 0.06,
              color: Colors.orangeAccent[200],
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: contextSize.height * 0.02),
              child: Text(this.identifier),
            ),
            subtitle: Text(
              this.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
