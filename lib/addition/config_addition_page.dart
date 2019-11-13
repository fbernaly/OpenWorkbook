import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'dart:io' show Platform;

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:grouped_buttons/grouped_buttons.dart';

import 'package:flutter_app/force_orientation.dart';
import 'package:flutter_app/math_operation.dart';

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

class ConfigAdditionPage extends StatefulWidget {
  ConfigAddition config;

  ConfigAdditionPage(this.config);

  createState() => ConfigAdditionPageState();
}

class ConfigAdditionPageState extends State<ConfigAdditionPage> {
  TextEditingController textControlllerMinA;
  TextEditingController textControlllerMinB;
  TextEditingController textControlllerMaxA;
  TextEditingController textControlllerMaxB;

  @override
  initState() {
    super.initState();

    textControlllerMinA = TextEditingController(text: "${widget.config.minA}");
    textControlllerMinB = TextEditingController(text: "${widget.config.minB}");
    textControlllerMaxA = TextEditingController(text: "${widget.config.maxA}");
    textControlllerMaxB = TextEditingController(text: "${widget.config.maxB}");
  }

  @override
  void dispose() {
    // update config
    widget.config.minA = int.parse(textControlllerMinA.text);
    widget.config.minB = int.parse(textControlllerMinB.text);
    widget.config.maxA = int.parse(textControlllerMaxA.text);
    widget.config.maxB = int.parse(textControlllerMaxB.text);

    // Clean up the controller when the widget is disposed.
    textControlllerMinA.dispose();
    textControlllerMinB.dispose();
    textControlllerMaxA.dispose();
    textControlllerMaxB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ForceOrientation.setPortrait(context);
    var textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Configure Addition/Subtraction Dojo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: Platform.isIOS ? 100 : 0),
            Text('Operation', style: textStyle),
            _radioButtonGroup(),
            Text('1st Number', style: textStyle),
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Text('Min:'),
                SizedBox(width: 8),
                Flexible(
                  child: PlatformTextField(
                    keyboardType: TextInputType.number,
                    controller: textControlllerMinA,
                  ),
                ),
                SizedBox(width: 20),
                Text('Max:'),
                SizedBox(width: 8),
                Flexible(
                  child: PlatformTextField(
                    keyboardType: TextInputType.number,
                    controller: textControlllerMaxA,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text('2nd Number', style: textStyle),
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Text('Min:'),
                SizedBox(width: 8),
                Flexible(
                  child: PlatformTextField(
                    keyboardType: TextInputType.number,
                    controller: textControlllerMinB,
                  ),
                ),
                SizedBox(width: 20),
                Text('Max:'),
                SizedBox(width: 8),
                Flexible(
                  child: PlatformTextField(
                    keyboardType: TextInputType.number,
                    controller: textControlllerMaxB,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  RadioButtonGroup _radioButtonGroup() {
    List<String> labels = <String>[
      "Addition",
      "Subtraction",
      "Addition/Subtraction",
    ];
    String picked = "";
    if (widget.config.operations.length == 1 &&
        widget.config.operations.contains(MathOperation.addition)) {
      picked = labels[0];
    } else if (widget.config.operations.length == 1 &&
        widget.config.operations.contains(MathOperation.subtraction)) {
      picked = labels[1];
    } else if (widget.config.operations.length == 2 &&
        widget.config.operations.contains(MathOperation.addition) &&
        widget.config.operations.contains(MathOperation.subtraction)) {
      picked = labels[2];
    }
    return RadioButtonGroup(
        labels: labels, picked: picked, onChange: _onChange);
  }

  void _onChange(String label, int index) {
    setState(() {
      if (index == 0)
        widget.config.operations = [MathOperation.addition];
      else if (index == 1)
        widget.config.operations = [MathOperation.subtraction];
      else if (index == 2)
        widget.config.operations = [
          MathOperation.addition,
          MathOperation.subtraction
        ];
    });
  }
}
