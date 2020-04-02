import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:tuple/tuple.dart';

import 'package:flutter_app/addition/addition_widget.dart';
import 'package:flutter_app/addition/config_addition_page.dart';
import 'package:flutter_app/widgets/dojo_state.dart';
import 'package:flutter_app/widgets/robot.dart';
import 'package:flutter_app/utils/math_operation.dart';
import 'package:flutter_app/utils/force_orientation.dart';
import 'package:flutter_app/utils/random.dart';
import 'package:flutter_app/utils/audio_player.dart';
import 'package:flutter_app/configuration/config_addition.dart';
import 'package:flutter_app/widgets/tutorial_page.dart';

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
  bool showErrorMessage = false;
  String message;
  Timer timer;
  DojoPageState state = DojoPageState.welcome;
  bool clear = false;

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
                icon: Icon(Icons.tune),
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
        return _getWelcomeWidget();

      case DojoPageState.configuration:
        return _getConfigWidget();

      case DojoPageState.working:
        return _getMainBodyWidget();
    }
  }

  Widget _getWelcomeWidget() {
    message == null;
    if (showWelcomeMessage) {
      message = "This is how you play!";
      showWelcomeMessage = false;
    }
    if (showErrorMessage) {
      message = "Wrong settings, tap the Options icon to fix";
    }
    _startHideMessageTimer();
    var p = Platform.isIOS ? "ios" : "android";
    List<Tuple2<String, String>> pages = [
      Tuple2('tutorial_drag_numbers_addition.png',
          'Drag or tap the numbers to enter your answer'),
      Tuple2('tutorial_options_' + p + '.png',
          'Tap this icon to change your options'),
      Tuple2('tutorial_skip_' + p + '.png', 'Tap this button to skip problems'),
      Tuple2('tutorial_back_' + p + '.png',
          'Tap back when you are done practicing')
    ];
    return TutorialPage(
      pages: pages,
      robotMessage: message,
      onRobotTap: () {
        setState(() {
          showWelcomeMessage = true;
        });
      },
      onOk: () => _startWorking(),
    );
  }

  Widget _getConfigWidget() {
    message == null;
    if (showWelcomeMessage) {
      message = "Select what you want to practice";
      showWelcomeMessage = false;
    }
    if (showErrorMessage) {
      message = "2nd number cannot be gratter than 1st number for subtraction";
      showErrorMessage = false;
    }
    _startHideMessageTimer();
    return ConfigAdditionPage(
      robotMessage: message,
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
      onTutorialTap: () => _showTutorial(),
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
        Positioned(
          right: Platform.isIOS ? 16 : 8,
          bottom: Platform.isIOS ? 16 : 4,
          child: PlatformButton(
              onPressed: () => _skipProblem(),
              child: PlatformText('Skip'),
              android: (_) => MaterialRaisedButtonData(
                  color: Colors.purple, textColor: Colors.white),
              ios: (_) => CupertinoButtonData(
                    color: Colors.purple,
                  )),
        ),
        RobotWidget(
          message: message,
          onTap: () {
            _showMessage("Drag or tap the numbers to enter your answer");
          },
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
      timer = Timer(Duration(seconds: 4), () {
        if (this.mounted) {
          setState(() {
            message = null;
          });
        }
      });
    }
  }

  void _startWorking() {
    if (config.operations.length == 1 &&
        config.operations.contains(MathOperation.subtraction) &&
        (config.maxA <= config.minB || config.maxA < config.maxB)) {
      setState(() {
        showErrorMessage = true;
      });
      return;
    }
    setState(() {
      message = null;
      state = DojoPageState.working;
    });
    _setOperation();
  }

  void _showConfig() {
    setState(() {
      showWelcomeMessage = true;
      state = DojoPageState.configuration;
    });
  }

  void _showTutorial() {
    setState(() {
      showWelcomeMessage = true;
      state = DojoPageState.welcome;
    });
  }

  void _onCorrectAnswer() {
    _showMessage(RandomGenerator.getRandomOkMessage());
    Future.delayed(const Duration(milliseconds: 1000), () {
      _setOperation();
    });
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
    operation = MathOperation.addition;
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
          min: 0,
          max: config.operations.length - 1,
          seed: DateTime.now().millisecondsSinceEpoch);
      operation = config.operations[i];
    }
    var a = RandomGenerator.generate(
        min: config.minA,
        max: config.maxA,
        initial: this.a,
        seed: DateTime.now().millisecondsSinceEpoch + 1);
    var b = RandomGenerator.generate(
        min: config.minB,
        max: config.maxB,
        initial: this.b,
        seed: DateTime.now().millisecondsSinceEpoch + 2);
    String symbol = operation == MathOperation.addition
        ? "+"
        : (operation == MathOperation.subtraction ? "-" : "");
    print("new operation: $a $symbol $b");
    if (operation == MathOperation.subtraction && (a - b) < 0) {
      print(
          "operations with negative result are not allowed, setting a new one...");
      _setOperation();
      return;
    }
    setState(() {
      this.a = a;
      this.b = b;
      this.clear = true;
    });
  }
}
