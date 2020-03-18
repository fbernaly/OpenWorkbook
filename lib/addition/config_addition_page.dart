import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_app/widgets/robot.dart';
import 'package:flutter_app/utils/math_operation.dart';

import 'package:grouped_buttons/grouped_buttons.dart';


class ConfigAddition {
  int minA = 10, minB = 2, maxA = 20, maxB = 9;
  List<MathOperation> operations = [MathOperation.addition];

  @override
  String toString() {
    return """
    minA: $minA, maxA: $maxA
    minB: $minB, maxB: $maxB
    operations: $operations""";
  }
}

class ConfigAdditionPage extends StatelessWidget {
  String title;
  String robotMessage;
  String buttonText;
  ConfigAddition config;
  void Function() onRobotTap;
  void Function() onOk;
  void Function(ConfigAddition) onConfigChange;
  final int max = 50;

  ConfigAdditionPage(
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
                    Row(
                      children: <Widget>[
                        Text('Operation', style: textStyle),
                        Center(
                          child: _radioButtonGroup(),
                        ),
                      ],
                    ),
                    Text(
                      "1st number from ${config.minA} to ${config.maxA}",
                      style: textStyle,
                    ),
                    RangeSlider(
                      min: 0,
                      max: max.toDouble(),
                      divisions: max,
                      values: RangeValues(
                          config.minA.toDouble(), config.maxA.toDouble()),
                      labels: RangeLabels(
                          config.minA.toString(), config.maxA.toString()),
                      onChanged: (values) {
                        config.minA = values.start.toInt();
                        config.maxA = values.end.toInt();
                        if (config.minA == max) config.minA = max - 1;
                        if (config.maxA - config.minA <= 0) {
                          config.maxA = config.minA + 1;
                        }
                        onConfigChange(config);
                      },
                    ),
                    Text(
                      "2nd number from ${config.minB} to ${config.maxB}",
                      style: textStyle,
                    ),
                    RangeSlider(
                      min: 0,
                      max: max.toDouble(),
                      divisions: max,
                      values: RangeValues(
                          config.minB.toDouble(), config.maxB.toDouble()),
                      labels: RangeLabels(
                          config.minB.toString(), config.maxB.toString()),
                      onChanged: (values) {
                        config.minB = values.start.toInt();
                        config.maxB = values.end.toInt();
                        if (config.minB == max) config.minB = max - 1;
                        if (config.maxB - config.minB <= 0) {
                          config.maxB = config.minB + 1;
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

  RadioButtonGroup _radioButtonGroup() {
    List<String> labels = <String>[
      "+",
      "-",
      "+/-",
    ];
    String picked = "";
    if (config.operations.length == 1 &&
        config.operations.contains(MathOperation.addition)) {
      picked = labels[0];
    } else if (config.operations.length == 1 &&
        config.operations.contains(MathOperation.subtraction)) {
      picked = labels[1];
    } else if (config.operations.length == 2 &&
        config.operations.contains(MathOperation.addition) &&
        config.operations.contains(MathOperation.subtraction)) {
      picked = labels[2];
    }
    return RadioButtonGroup(
        labels: labels,
        picked: picked,
        orientation: GroupedButtonsOrientation.HORIZONTAL,
        labelStyle:
            TextStyle(color: Colors.purple, fontWeight: FontWeight.w400),
        onChange: _onRadioButtonGroupChange);
  }

  void _onRadioButtonGroupChange(String label, int index) {
    if (index == 0)
      config.operations = [MathOperation.addition];
    else if (index == 1)
      config.operations = [MathOperation.subtraction];
    else if (index == 2)
      config.operations = [MathOperation.addition, MathOperation.subtraction];
    onConfigChange(config);
  }
}
