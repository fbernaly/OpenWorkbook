import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'dart:async';

import 'package:flutter_app/comparison/comparison_widget.dart';
import 'package:flutter_app/comparison/config_comparison_page.dart';
import 'package:flutter_app/widgets/dojo_state.dart';
import 'package:flutter_app/widgets/robot.dart';
import 'package:flutter_app/utils/force_orientation.dart';
import 'package:flutter_app/utils/random.dart';
import 'package:flutter_app/utils/audio_player.dart';

class ComparisonPage extends StatefulWidget {
  String title = "Comparison Dojo";

  createState() => ComparisonState();
}

class ComparisonState extends State<ComparisonPage> {
  int a, b;
  ConfigComparison config = ConfigComparison();
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
              child: IconButton(
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
    return ConfigComparisonPage(
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
        ComparisonWidget(
          a: a,
          b: b,
          clear: clear,
          onOk: () => _onCorrectAnswer(),
          onReview: () => _onReviewAnswer(),
          onError: () => _onIncorrectAnswer(),
        ),
        RobotWidget(
          message: message,
          onTap: () {
            _showMessage("Drag the symbols to enter your answer.");
          },
        ),
        Positioned(
          right: 16.0,
          bottom: 16.0,
          child: PlatformButton(
              onPressed: () => _skipProblem(),
              child: PlatformText('SKIP'),
              android: (_) => MaterialRaisedButtonData(
                  color: Colors.purple, textColor: Colors.white)),
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

  void _onIncorrectAnswer() {
    _showMessage(RandomGenerator.getRandomErrorMessage());
  }

  void _onReviewAnswer() {
    _showMessage(RandomGenerator.getRandomReviewMessage());
  }

  void _skipProblem() {
    _plyr.playSkipSound();
    _showMessage(RandomGenerator.getRandomSkipMessage());
    _setOperation();
  }

  void _setOperation() {
    print("config:\n$config");
    var a = this.a;
    do {
      a = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch,
          min: config.min,
          max: config.max);
    } while (this.a == a);
    var b = this.b;
    do {
      b = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch + 1,
          min: config.min,
          max: config.max);
    } while (this.b == b);
    setState(() {
      this.a = a;
      this.b = b;
      this.clear = true;
    });
  }
}
