import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:audioplayers/audio_cache.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'dart:math';

import 'package:flutter_app/addition/addition_widget.dart';
import 'package:flutter_app/addition/config_addition_page.dart';
import 'package:flutter_app/draggable.dart';

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

  int a, b, minA = 0, minB = 0, maxA = 10, maxB = 2;
  AudioCache _plyr = AudioCache();

  HomeState() {
    _setOperators();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text('Open Workbook'),
          trailingActions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _edit(),
            ),
          ],
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
                  return DraggableNumber(number: number);
                }).toList()),
            Expanded(
              child: new AdditionWidget(
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
                        CupertinoIcons.delete,
                        size: 35.0,
                      ),
                      androidIcon: Icon(Icons.delete, size: 35.0)),
                  SizedBox(width: 15)
                ]),
            SizedBox(height: 15),
          ],
        ));
  }

  void _edit() {
    WidgetBuilder pageToDisplayBuilder = (_) => ConfigAdditionPage();
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
      _setOperators();
    });
  }

  void _reload() {
    _plyr.play('swoosh.mp3');
    setState(() {
      _setOperators();
    });
  }

  void _setOperators() {
    var a = this.a;
    do {
      a = _next(minA, maxA);
    } while (this.a == a);
    this.a = a;
    var b = this.b;
    do {
      b = _next(minB, maxB);
    } while (this.b == b);
    this.b = b;
    print("setting operators, a: $a, b: $b");
  }

  /**
   * Generates a positive random integer uniformly distributed on the range
   * from [min], inclusive, to [max], exclusive.
   */
  int _next(int min, int max) =>
      min + Random(DateTime.now().millisecondsSinceEpoch).nextInt(max - min);
}
