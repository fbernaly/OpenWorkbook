import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:tuple/tuple.dart';

import 'package:flutter_app/number_bond/number_bond_widget.dart';
import 'package:flutter_app/number_bond/config_number_bond_page.dart';
import 'package:flutter_app/utils/force_orientation.dart';
import 'package:flutter_app/utils/random.dart';
import 'package:flutter_app/utils/audio_player.dart';
import 'package:flutter_app/widgets/dojo_state.dart';
import 'package:flutter_app/widgets/robot.dart';
import 'package:flutter_app/configuration/config_number_bond.dart';
import 'package:flutter_app/widgets/tutorial_page.dart';

class NumberBondPage extends StatefulWidget {
  String title = "Number Bond Dojo";

  createState() => NumberBondState();
}

class NumberBondState extends State<NumberBondPage> {
  int a, b, c;
  ConfigNumberBond config = ConfigNumberBond();
  AudioPlayer _plyr = AudioPlayer();
  bool showWelcomeMessage = true;
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
    _startHideMessageTimer();
    List<Tuple2<String, String>> pages = [
      Tuple2('tutorial_drag_numbers_bond.png',
          'Drag or tap the numbers to enter your answer'),
      Tuple2('tutorial_options.png', 'Tap this icon to change your options'),
      Tuple2('tutorial_skip.png', 'Tap this button to skip problems'),
      Tuple2('tutorial_back.png', 'Tap back when you are done practicing')
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
    String title, buttonText;
    _startHideMessageTimer();
    return ConfigNumberBondPage(
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
        NumberBondWidget(
          a: a,
          b: b,
          c: c,
          clear: clear,
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
    if (config.max - config.min <= 1) return;
    print("config:\n$config");
    this.c = RandomGenerator.generate(
        seed: DateTime.now().millisecondsSinceEpoch,
        min: config.min,
        max: config.max,
        initial: this.c);

    if (c == 0) {
      this.a = 0;
    } else {
      this.a = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch + 1,
          min: 0,
          max: c,
          initial: this.a);
    }

    this.b = c - a;

    print("new operation: $a + $b = $c");

    setState(() {
      var i = RandomGenerator.generate(
              seed: DateTime.now().millisecondsSinceEpoch + 2,
              min: 0,
              max: 100) %
          4;
      if (i == 0) {
        this.c = null;
      } else if (i == 1) {
        this.a = null;
      } else if (i == 2) {
        this.b = null;
      } else if (i == 3) {
        this.a = null;
        this.b = null;
      }
      this.clear = true;
    });
  }
}
