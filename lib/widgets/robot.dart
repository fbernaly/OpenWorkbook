import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_app/widgets/message_label.dart';

import 'package:lottie/lottie.dart';

import 'dart:io' show Platform;

enum RobotSize { large, small }

class RobotWidget extends StatelessWidget {
  String message;
  RobotSize size = RobotSize.large;
  void Function() onTap;

  RobotWidget({Key key, this.message, this.size, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 100;
    double height = 150;
    double left = Platform.isIOS ? 0 : -40;
    double bottom = Platform.isIOS ? 0 : -10;
    double mLeft = 40;
    double mTop = Platform.isIOS ? 60 : 80;

    switch (size) {
      case RobotSize.small:
        width = 100;
        height = 100;
        left = -20;
        bottom = 0;
        mLeft = 0;
        mTop = 50;
        break;
    }

    var messageWidget = message == null
        ? SizedBox(width: 0, height: 0)
        : MessageLabel(
            message: message,
            left: mLeft,
            top: mTop,
          );

    return Positioned(
      left: left,
      bottom: bottom,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (this.onTap != null) this.onTap();
            },
            child: Lottie.asset(
              'assets/10178-c-bot.json',
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          messageWidget,
        ],
      ),
    );
  }
}
