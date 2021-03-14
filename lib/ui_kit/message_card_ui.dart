import 'package:flutter/material.dart';

class MessageCardUi extends StatelessWidget {
  final String identifier;
  final String description;

  const MessageCardUi({Key key, this.identifier, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contextSize = MediaQuery.of(context).size;
    
    return Container(
      width: contextSize.width * 0.8,
      // height: MediaQuery.of(context).size.width * 0.1,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          // contentPadding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 20.0),

          leading: Icon(
            Icons.warning_amber_rounded,
            size: contextSize.height * 0.06,
            color: Colors.orangeAccent[200],
          ),
          title: Padding(
            padding: EdgeInsets.only(bottom: contextSize.height * 0.02),
            child: Text(this.identifier),
          ),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(children: [
              Text(
                this.description,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ])
          ]),

          // Container(
          //     width: MediaQuery.of(context).size.width * 0.8,
          //     child: Row(
          //       children: <Widget>[
          //         Expanded(
          //           child: Text(this.description),
          //         )
          //       ],
          //     ))

          // Text(
          //   this.description.length > 150
          //       ? this
          //           .description
          //           .replaceRange(140, this.description.length, '...')
          //       : this.description,
          // ),
        ),
      ),
    );
  }
}
