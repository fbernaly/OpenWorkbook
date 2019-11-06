import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';

import 'draggable.dart';
import 'target.dart';

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> {
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

  int a, b, minA = 0, minB = 0, maxA = 20, maxB = 10;
  AudioCache _plyr = AudioCache();

  HomeState() {
    _setOperators();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text('Open Workbook'),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: numbers.keys.map((emoji) {
                  var number =
                      DraggableNumberInfo(emoji: emoji, value: numbers[emoji]);
                  return DraggableWidget(number: number);
                }).toList()),
            Expanded(
              child: new TargetWidget(
                a: a,
                b: b,
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

  void _onOk() {
    setState(() {
      _setOperators();
    });
  }

  void _reload() {
    _plyr.play('uhOhBaby.mp3');
    setState(() {
      _setOperators();
    });
  }

  void _setOperators() {
    a = _next(minA, maxA);
    b = _next(minB, maxB);
    print("setting operators, a: $a, b: $b");
  }

  /**
   * Generates a positive random integer uniformly distributed on the range
   * from [min], inclusive, to [max], exclusive.
   */
  int _next(int min, int max) =>
      min + Random(DateTime.now().millisecondsSinceEpoch).nextInt(max - min);
}
