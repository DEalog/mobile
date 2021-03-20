import 'package:flutter/material.dart';

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

    return SizedBox(
      width: _width,
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
    );
  }
}
