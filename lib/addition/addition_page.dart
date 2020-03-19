import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_app/addition/addition_widget.dart';
import 'package:flutter_app/addition/config_addition_page.dart';
import 'package:flutter_app/widgets/dojo_state.dart';
import 'package:flutter_app/widgets/robot.dart';
import 'package:flutter_app/utils/math_operation.dart';
import 'package:flutter_app/utils/force_orientation.dart';
import 'package:flutter_app/utils/random.dart';
import 'package:flutter_app/utils/audio_player.dart';

class AdditionSubtractionPage extends StatefulWidget {
  String title = "Addition/Subtraction Dojo";

  createState() => AdditionSubtractionState();
}

class AdditionSubtractionState extends State<AdditionSubtractionPage> {
  int a, b;
  MathOperation operation;
  ConfigAddition config = ConfigAddition();
  AudioPlayer _plyr = AudioPlayer();
  bool showWelcomeMessage = true;
  String message;
  Timer timer;
  DojoPageState state = DojoPageState.welcome;
  bool clear = false;

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
          Material(
              color: Colors.purple,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.settings),
                onPressed: () => _showConfig(),
              )),
        ],
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    switch (state) {
      case DojoPageState.welcome:
        return _getConfigWidget();

      case DojoPageState.configuration:
        return _getConfigWidget();

      case DojoPageState.working:
        return _getMainBodyWidget();
    }
  }

  Widget _getConfigWidget() {
    message == null;
    if (showWelcomeMessage) {
      message = "Select what you want to practice";
      showWelcomeMessage = false;
    }
    String title, buttonText;
    switch (state) {
      case DojoPageState.welcome:
        title = "Welcome";
        buttonText = "START";
        break;

      case DojoPageState.configuration:
        title = "Options";
        buttonText = "OK";
        break;
    }
    _startHideMessageTimer();
    return ConfigAdditionPage(
      title: title,
      robotMessage: message,
      buttonText: buttonText,
      config: config,
      onRobotTap: () {
        setState(() {
          showWelcomeMessage = true;
        });
      },
      onConfigChange: (config) {
        setState(() {
          this.config = config;
        });
      },
      onOk: () => _startWorking(),
    );
  }

  Widget _getMainBodyWidget() {
    var clear = this.clear;
    this.clear = false;
    return Stack(
      children: <Widget>[
        AdditionWidget(
          a: a,
          b: b,
          clear: clear,
          operation: operation,
          onOk: () => _onCorrectAnswer(),
          onReview: () => _onReviewAnswer(),
          onError: () => _onIncorrectAnswer(),
        ),
        RobotWidget(
          message: message,
          onTap: () {
            _showMessage("Drag or tap the numbers to enter your answer.");
          },
        ),
        Positioned(
          right: Platform.isIOS ? 16 : 8,
          bottom: Platform.isIOS ? 16 : 4,
          child: PlatformButton(
              onPressed: () => _skipProblem(),
              child: PlatformText('SKIP'),
              android: (_) => MaterialRaisedButtonData(
                  color: Colors.purple, textColor: Colors.white),
              ios: (_) => CupertinoButtonData(
                    color: Colors.purple,
                  )),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    setState(() {
      this.message = message;
    });
    _startHideMessageTimer();
  }

  void _startHideMessageTimer() {
    timer?.cancel();
    if (message != null) {
      timer = Timer(Duration(seconds: 2), () {
        setState(() {
          message = null;
        });
      });
    }
  }

  void _startWorking() {
    setState(() {
      message = null;
      state = DojoPageState.working;
    });
    _setOperation();
  }

  void _showConfig() {
    setState(() {
      message = null;
      state = DojoPageState.configuration;
    });
  }

  void _onCorrectAnswer() {
    _showMessage(RandomGenerator.getRandomOkMessage());
    _setOperation();
  }

  void _onReviewAnswer() {
    _showMessage(RandomGenerator.getRandomReviewMessage());
  }

  void _onIncorrectAnswer() {
    _showMessage(RandomGenerator.getRandomErrorMessage());
  }

  void _skipProblem() {
    _plyr.playSkipSound();
    _showMessage(RandomGenerator.getRandomSkipMessage());
    _setOperation();
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
          seed: DateTime.now().millisecondsSinceEpoch,
          min: 0,
          max: config.operations.length);
      print("i: ${i} ${config.operations.length}");
      operation = config.operations[i];
    }
    var a = this.a;
    do {
      a = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch,
          min: config.minA,
          max: config.maxA);
    } while (this.a == a);
    var b = this.b;
    do {
      b = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch + 1,
          min: config.minB,
          max: config.maxB);
    } while (this.b == b);
    String symbol = operation == MathOperation.addition
        ? "+"
        : (operation == MathOperation.subtraction ? "-" : "");
    print("new operation: $a $symbol $b");
    if (operation == MathOperation.subtraction && (a - b) < 0) {
      print(
          "operations with negative result are not allowed, setting a new one...");
      _setOperation();
    }
    setState(() {
      this.a = a;
      this.b = b;
      this.clear = true;
    });
  }
}
