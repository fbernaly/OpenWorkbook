import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:audioplayers/audio_cache.dart';

import 'dart:math';

import 'draggable.dart';

typedef TargetAccept = void Function();

class TargetWidget extends StatefulWidget {
  final int a;
  final int b;
  final int minA, minB, maxA, maxB;
  final TargetAccept onOk;

  TargetWidget(
      {this.a, this.b, this.minA, this.maxA, this.minB, this.maxB, this.onOk});

  createState() => TargetWidgetState(
      a: a, b: b, minA: minA, maxA: maxA, minB: minB, maxB: maxB, onOk: onOk);
}

class TargetWidgetState extends State<TargetWidget> {
  List<DraggableNumberInfo> numbers = [];
  final int _maxDigits = 3;
  int a, b, minA, minB, maxA, maxB;
  final TargetAccept onOk;
  AudioCache _plyr = AudioCache();

  TargetWidgetState(
      {this.a, this.b, this.minA, this.maxA, this.minB, this.maxB, this.onOk}) {
    if (minA == null) this.minA = 0;
    if (maxA == null) this.maxA = 20;
    if (minB == null) this.minB = 0;
    if (maxB == null) this.maxB = 20;
    print("a [$minA, $maxA]");
    print("b [$minB, $maxB]");
    if (a == null) a = _next(minA, maxA);
    if (b == null) b = _next(minB, maxB);
  }

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(color: Colors.black, fontSize: 30);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "$a",
          style: style,
        ),
        SizedBox(width: 8),
        Text(
          '+',
          style: style,
        ),
        SizedBox(width: 8),
        Text(
          '$b',
          style: style,
        ),
        SizedBox(width: 8),
        Text(
          '=',
          style: style,
        ),
        SizedBox(width: 8),
        _buildDragTarget(),
      ],
    );
  }

  Widget _buildDragTarget() {
    return DragTarget<DraggableNumberInfo>(
      builder: (BuildContext context, List<DraggableNumberInfo> incoming,
          List rejected) {
        Widget child;
        if (numbers.length == 0) {
          child = Center(child: Text('___________'));
        } else {
          var i = 0;
          child = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: numbers.map((number) {
              number.index = i++;
              return DraggableWidget(number: number);
            }).toList(),
          );
        }
        return Container(
          color: Colors.grey,
          child: child,
          height: 80,
          width: 150,
        );
      },
      onWillAccept: (number) =>
          number.index == null && (numbers.length + 1 <= _maxDigits),
      onAccept: (number) {
        print("Adding: ${number.emoji}");
        setState(() {
          numbers.add(DraggableNumberInfo.from(number));
          checkAnswer();
        });
      },
      onLeave: (number) {
        if (numbers.length == 0) return;
        var i = number.index;
        if (i == null) return;
        var emoji = number.emoji;
        if (numbers.length <= i) return;
        if (numbers[i].emoji != emoji) return;
        print("Removing: $emoji at index $i");
        setState(() {
          numbers.removeAt(i);
          checkAnswer();
        });
      },
    );
  }

  void checkAnswer() {
    if (numbers.length == 0) return;
    var str = "";
    numbers.forEach((number) => str += "${number.value}");
    var response = int.parse(str);
    print("Current response: $response");
    if (a + b == response) {
      print("response is correct!!");
      _plyr.play('success.mp3');
      if (onOk != null) onOk();
      setState(() {
        numbers = [];
        a = _next(minA, maxA);
        b = _next(minB, maxB);
      });
    }
  }

  /**
   * Generates a positive random integer uniformly distributed on the range
   * from [min], inclusive, to [max], exclusive.
   */
  int _next(int min, int max) =>
      min + Random(DateTime.now().millisecondsSinceEpoch).nextInt(max - min);
}
