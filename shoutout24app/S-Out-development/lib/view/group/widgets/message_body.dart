import 'package:flutter/material.dart';
import 'package:shoutout24/utils/color.dart';

class MessageBody extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final String time;

  MessageBody({this.message, this.sender, this.sentByMe, this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4, bottom: 4, left: sentByMe ? 0 : 24, right: sentByMe ? 24 : 0),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sentByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          color: sentByMe ? colorOrange : colorAccent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(sender,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5)),
            SizedBox(height: sentByMe ? 0.0 : 7.0),
            Text(message,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15.0, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
