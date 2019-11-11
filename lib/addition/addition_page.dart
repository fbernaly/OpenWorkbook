import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:audioplayers/audio_cache.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'dart:math';
import 'dart:io' show Platform;

import 'package:flutter_app/addition/addition_widget.dart';
import 'package:flutter_app/addition/config_addition_page.dart';
import 'package:flutter_app/draggable.dart';
import 'package:flutter_app/math_operation.dart';
import 'package:flutter_app/force_orientation.dart';

class AdditionSubtractionPage extends StatefulWidget {
  createState() => AdditionSubtractionState();
}

class AdditionSubtractionState extends State<AdditionSubtractionPage> {
  /// Choices for game
  final Map numbers = {
    '0⃣': 0,
    '1⃣': 1,
    '2⃣': 2,
    '3⃣': 3,
    '4⃣': 4,
    '5⃣': 5,
    '6⃣': 6,
    '7⃣': 7,
    '8⃣': 8,
    '9⃣': 9,
  };

  int a, b;
  MathOperation operation;
  ConfigAddition config = ConfigAddition();
  AudioCache _plyr = AudioCache();

  AdditionSubtractionState() {
    _setOperation();
  }

  @override
  Widget build(BuildContext context) {
    ForceOrientation.setLandscape(context);
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text('Addition/Subtraction Dojo'),
          trailingActions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _config(),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: Platform.isIOS ? 60 : 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: numbers.keys.map((emoji) {
                  var number =
                      DraggableNumberInfo(emoji: emoji, value: numbers[emoji]);
                  return DraggableNumber(number: number);
                }).toList()),
            Expanded(
              child: new AdditionWidget(
                a: a,
                b: b,
                operation: operation,
                onOk: () => _onOk(),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PlatformIconButton(
                      onPressed: () => _reload(),
                      iosIcon: Icon(
                        CupertinoIcons.refresh,
                        size: 35.0,
                      ),
                      androidIcon: Icon(Icons.refresh, size: 35.0)),
                  SizedBox(width: 15)
                ]),
            SizedBox(height: 15),
          ],
        ));
  }

  void _config() {
    WidgetBuilder pageToDisplayBuilder = (_) => ConfigAdditionPage(config);
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: pageToDisplayBuilder,
      ),
    );
  }

  void _onOk() {
    setState(() {
      _setOperation();
    });
  }

  void _reload() {
    _plyr.play('swoosh.mp3');
    setState(() {
      _setOperation();
    });
  }

  void _setOperation() {
    print("config:\n$config");
    if (config.operations.length == 1 &&
        config.operations.contains(MathOperation.addition)) {
      operation = MathOperation.addition;
    } else if (config.operations.length == 1 &&
        config.operations.contains(MathOperation.subtraction)) {
      operation = MathOperation.subtraction;
    } else if (config.operations.length == 2 &&
        config.operations.contains(MathOperation.addition) &&
        config.operations.contains(MathOperation.subtraction)) {
      int i = Random(DateTime.now().millisecondsSinceEpoch).nextInt(100) % 2;
      operation = config.operations[i];
    }
    var a = this.a;
    do {
      a = _next(config.minA, config.maxA);
    } while (this.a == a);
    this.a = a;
    var b = this.b;
    do {
      b = _next(config.minB, config.maxB);
    } while (this.b == b);
    this.b = b;
    String symbol = operation == MathOperation.addition
        ? "+"
        : (operation == MathOperation.subtraction ? "-" : "");
    print("new operation: $a $symbol $b");
    if (operation == MathOperation.subtraction && (a - b) < 0) {
      print(
          "operations with negative result are not allowed, setting a new one...");
      _setOperation();
    }
  }

  /**
   * Generates a positive random integer uniformly distributed on the range
   * from [min], inclusive, to [max], exclusive.
   */
  int _next(int min, int max) =>
      min + Random(DateTime.now().millisecondsSinceEpoch).nextInt(max - min);
}
