import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_app/widgets/robot.dart';
import 'package:flutter_app/utils/math_operation.dart';
import 'package:flutter_app/configuration/config_addition.dart';

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
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: Platform.isIOS ? 10 : 0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Operation', style: textStyle),
                        _getOptions()
                      ],
                    ),
                    SizedBox(height: Platform.isIOS ? 20 : 0),
                    Text(
                      "1st number from ${config.minA} to ${config.maxA}",
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
                        )),
                    Text(
                      "2nd number from ${config.minB} to ${config.maxB}",
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
                        )),
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
            right: Platform.isIOS ? 16 : 8,
            bottom: Platform.isIOS ? 16 : 4,
            child: PlatformButton(
                onPressed: () => onOk(),
                child: PlatformText(buttonText),
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

  Widget _getOptions() {
    return Platform.isIOS ? _getSegmentedControl() : _radioButtonGroup();
  }

  Widget _getSegmentedControl() {
    var index = _getOperationOption();
    return Expanded(
      child: Container(
        height: 60,
        color: Colors.white,
        child: CupertinoSegmentedControl(
          children: {0: Text("+"), 1: Text("-"), 2: Text("+/-")},
          groupValue: index,
          onValueChanged: (index) {
            _onOperationOptionChange(index);
          },
        ),
      ),
    );
  }

  Widget _radioButtonGroup() {
    List<String> labels = <String>[
      "+",
      "-",
      "+/-",
    ];
    var index = _getOperationOption();
    String picked = labels[index];
    return Center(
        child: RadioButtonGroup(
            labels: labels,
            picked: picked,
            orientation: GroupedButtonsOrientation.HORIZONTAL,
            labelStyle:
                TextStyle(color: Colors.purple, fontWeight: FontWeight.w400),
            onChange: _onRadioButtonGroupChange));
  }

  void _onRadioButtonGroupChange(String label, int index) {
    _onOperationOptionChange(index);
  }

  int _getOperationOption() {
    int index = -1;
    if (config.operations.length == 1 &&
        config.operations.contains(MathOperation.addition)) {
      index = 0;
    } else if (config.operations.length == 1 &&
        config.operations.contains(MathOperation.subtraction)) {
      index = 1;
    } else if (config.operations.length == 2 &&
        config.operations.contains(MathOperation.addition) &&
        config.operations.contains(MathOperation.subtraction)) {
      index = 2;
    }
    return index;
  }

  void _onOperationOptionChange(int index) {
    if (index == 0)
      config.operations = [MathOperation.addition];
    else if (index == 1)
      config.operations = [MathOperation.subtraction];
    else if (index == 2)
      config.operations = [MathOperation.addition, MathOperation.subtraction];
    onConfigChange(config);
  }
}
