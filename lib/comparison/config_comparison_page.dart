import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_app/widgets/robot.dart';
import 'package:flutter_app/configuration/config_comparison.dart';

class ConfigComparisonPage extends StatelessWidget {
  String robotMessage;
  ConfigComparison config;
  void Function() onRobotTap;
  void Function() onOk;
  void Function() onTutorialTap;
  void Function(ConfigComparison) onConfigChange;
  final int max = 100;

  ConfigComparisonPage(
      {Key key,
      this.robotMessage,
      this.config,
      this.onRobotTap,
      this.onConfigChange,
      this.onTutorialTap,
      this.onOk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle =
        TextStyle(color: Colors.purple, fontWeight: FontWeight.bold);
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
              SizedBox(height: 16),
              Text(
                "Options",
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Numbers from ${config.min} to ${config.max}",
                      style: textStyle,
                    ),
                    Material(
                        color: Colors.white,
                        child: RangeSlider(
                          min: 0,
                          max: max.toDouble(),
                          divisions: max,
                          activeColor: Colors.purple,
                          inactiveColor: Colors.purple.withAlpha(50),
                          values: RangeValues(
                              config.min.toDouble(), config.max.toDouble()),
                          labels: RangeLabels(
                              config.min.toString(), config.max.toString()),
                          onChanged: (values) {
                            config.min = values.start.toInt();
                            config.max = values.end.toInt();
                            if (config.min == max) config.min = max - 1;
                            if (config.max - config.min <= 0) {
                              config.max = config.min + 1;
                            }
                            onConfigChange(config);
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: Platform.isIOS ? 16 : 8,
            bottom: Platform.isIOS ? 16 : 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PlatformButton(
                    onPressed: () => onTutorialTap(),
                    child: PlatformText("Tutorial"),
                    android: (_) => MaterialRaisedButtonData(
                        color: Colors.purple, textColor: Colors.white),
                    ios: (_) => CupertinoButtonData(
                          color: Colors.purple,
                        )),
                SizedBox(width: 8), // give it width
                PlatformButton(
                    onPressed: () => onOk(),
                    child: PlatformText("Ok"),
                    android: (_) => MaterialRaisedButtonData(
                        color: Colors.purple, textColor: Colors.white),
                    ios: (_) => CupertinoButtonData(
                          color: Colors.purple,
                        )),
              ],
            ),
          ),
          RobotWidget(
            message: robotMessage,
            size: RobotSize.small,
            onTap: () => this.onRobotTap(),
          ),
        ],
      ), //Your child widget
    );
  }
}
