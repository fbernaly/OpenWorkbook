import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:audioplayers/audio_cache.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'dart:io' show Platform;

import 'package:flutter_app/addition/addition_widget.dart';
import 'package:flutter_app/addition/config_addition_page.dart';
import 'package:flutter_app/draggable/number.dart';
import 'package:flutter_app/math_operation.dart';
import 'package:flutter_app/force_orientation.dart';
import 'package:flutter_app/random.dart';

class AdditionSubtractionPage extends StatefulWidget {
  String title = "Addition/Subtraction Dojo";

  createState() => AdditionSubtractionState();
}

class AdditionSubtractionState extends State<AdditionSubtractionPage> {
  int a, b;
  MathOperation operation;
  ConfigAddition config = ConfigAddition();
  AudioCache _plyr = AudioCache();

  @override
  initState() {
    super.initState();

    _setOperation();
  }

  @override
  Widget build(BuildContext context) {
    ForceOrientation.setLandscape(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.title),
        trailingActions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _config(),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: Platform.isIOS ? 60 : 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: DraggableNumber.getNumbers()),
              Expanded(
                child: AdditionWidget(
                  a: a,
                  b: b,
                  operation: operation,
                  onOk: () => _onOk(),
                ),
              ),
            ],
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: PlatformIconButton(
                onPressed: () => _reload(),
                iosIcon: Icon(
                  CupertinoIcons.refresh,
                  size: 35.0,
                ),
                androidIcon: Icon(Icons.refresh, size: 35.0)),
          )
        ],
      ),
    );
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
      int i = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch, min: 0, max: 100);
      operation = config.operations[i];
    }
    var a = this.a;
    do {
      a = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch,
          min: config.minA,
          max: config.maxA);
    } while (this.a == a);
    this.a = a;
    var b = this.b;
    do {
      b = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch + 1,
          min: config.minB,
          max: config.maxB);
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
}
