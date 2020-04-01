import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:tuple/tuple.dart';

import 'package:flutter_app/widgets/robot.dart';
import 'package:flutter_app/widgets/carousel.dart';

class TutorialPage extends StatelessWidget {
  List<Tuple2<String, String>> pages;
  String robotMessage;
  void Function() onRobotTap;
  void Function() onOk;

  TutorialPage({Key key, this.pages, this.robotMessage, this.onRobotTap, this.onOk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Platform.isIOS ? 60 : 20,
          right: Platform.isIOS ? 60 : 20,
          top: 20,
          bottom: 20),
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
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Carousel(
                items: _getCarouselItems(context),
              ),
            ],
          ),
          RobotWidget(
            message: robotMessage,
            size: RobotSize.small,
            onTap: () => this.onRobotTap(),
          ),
          Positioned(
            right: Platform.isIOS ? 16 : 8,
            bottom: Platform.isIOS ? 16 : 4,
            child: PlatformButton(
                onPressed: () => onOk(),
                child: PlatformText("Start"),
                android: (_) => MaterialRaisedButtonData(
                    color: Colors.purple, textColor: Colors.white),
                ios: (_) => CupertinoButtonData(
                      color: Colors.purple,
                    )),
          ),
        ],
      ), //Your child widget
    );
  }

  List<Widget> _getCarouselItems(BuildContext context) {
    return pages.map((page) {
      int index = pages.indexOf(page);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            pages[index].item2,
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage(pages[index].item1),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
