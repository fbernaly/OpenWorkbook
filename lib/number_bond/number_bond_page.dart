import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'dart:async';

import 'package:flutter_app/number_bond/number_bond_widget.dart';
import 'package:flutter_app/number_bond/config_number_bond_page.dart';
import 'package:flutter_app/utils/force_orientation.dart';
import 'package:flutter_app/utils/random.dart';
import 'package:flutter_app/utils/audio_player.dart';
import 'package:flutter_app/widgets/dojo_state.dart';
import 'package:flutter_app/widgets/robot.dart';

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
            icon: Icon(Icons.settings),
            onPressed: () => _showConfig(),
          ),
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
    return ConfigNumberBondPage(
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
        NumberBondWidget(
          a: a,
          b: b,
          c: c,
          clear: clear,
          onOk: () => _onCorrectAnswer(),
          onReview: () => _onReviewAnswer(),
          onError: () => _onIncorrectAnswer(),
        ),
        RobotWidget(
          message: message,
          onTap: () {
            _showMessage("Drag the numbers to enter your answer.");
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
    var c = this.c;
    do {
      c = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch,
          min: config.min,
          max: config.max);
    } while (this.c == c);
    this.c = c;

    if (c == 0) {
      this.a = 0;
    } else {
      var a = this.a;
      do {
        a = RandomGenerator.generate(
            seed: DateTime.now().millisecondsSinceEpoch + 1, min: 0, max: c);
      } while (this.a == a);
      this.a = a;
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
