import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_app/widgets/robot.dart';

class ConfigNumberBond {
  int min = 10, max = 20;

  @override
  String toString() {
    return """
    min: $min, max: $max""";
  }
}

class ConfigNumberBondPage extends StatelessWidget {
  String title;
  String robotMessage;
  String buttonText;
  ConfigNumberBond config;
  void Function() onRobotTap;
  void Function() onOk;
  void Function(ConfigNumberBond) onConfigChange;
  final int max = 100;

  ConfigNumberBondPage(
      {Key key,
      this.title,
      this.robotMessage,
      this.buttonText,
      this.config,
      this.onRobotTap,
      this.onConfigChange,
      this.onOk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle =
        TextStyle(color: Colors.purple, fontWeight: FontWeight.bold);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Numbers from ${config.min} to ${config.max}",
                      style: textStyle,
                    ),
                    RangeSlider(
                      min: 0,
                      max: max.toDouble(),
                      divisions: max,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
          RobotWidget(
            message: robotMessage,
            size: RobotSize.small,
            onTap: () => this.onRobotTap(),
          ),
          Positioned(
            right: 8.0,
            bottom: 4.0,
            child: PlatformButton(
                onPressed: () => onOk(),
                child: PlatformText(buttonText),
                android: (_) => MaterialRaisedButtonData(
                    color: Colors.purple, textColor: Colors.white)),
          ),
        ],
      ), //Your child widget
    );
  }
}
