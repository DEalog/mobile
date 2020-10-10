import 'package:flutter/material.dart';

class MessageCardUi extends StatelessWidget {
  final String identifier;
  final String description;

  const MessageCardUi({Key key, this.identifier, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.warning_amber_rounded,
                size: MediaQuery.of(context).size.height * 0.06,
                color: Colors.orangeAccent[200],
              ),
              title: Text(this.identifier),
              subtitle: Text(this.description),
            ),
          ],
        ),
      ),
    );
  }
}
