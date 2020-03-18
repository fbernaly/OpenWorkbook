import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageLabel extends StatelessWidget {

  double left = 40;
  double top = 80;
  MessageLabel({Key key, this.message, this.left, this.top}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: left, top: top),
      padding: EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.purple.withAlpha(85),
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        boxShadow: [
          BoxShadow(blurRadius: 5, color: Colors.purple, offset: Offset(1, 2))
        ],
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
      ), //Your child widget
    );
  }
}
