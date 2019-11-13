import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:audioplayers/audio_cache.dart';

import 'package:flutter_app/draggable/number.dart';

class NumberBondWidget extends StatefulWidget {
  int a;
  int b;
  int c;
  void Function() onOk;

  NumberBondWidget({this.a, this.b, this.c, this.onOk});

  createState() => NumberBondState();
}

class NumberBondState extends State<NumberBondWidget> {
  Widget _widgetA, _widgetB, _widgetC;
  List<DraggableNumberInfo> _numbersA = [], _numbersB = [], _numbersC = [];
  final int _maxDigits = 3;
  AudioCache _plyr = AudioCache();
  Timer _t;

  @override
  Widget build(BuildContext context) {
    double radius = 45;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _widgetC = _buildDragTarget(
            radius: radius, value: widget.c, numbers: _numbersC),
        Text('/              \\'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _widgetA = _buildDragTarget(
                radius: radius, value: widget.a, numbers: _numbersA),
            SizedBox(width: 20),
            _widgetB = _buildDragTarget(
                radius: radius, value: widget.b, numbers: _numbersB),
          ],
        ),
      ],
    );
  }

  Widget _buildDragTarget(
      {double radius, int value, List<DraggableNumberInfo> numbers}) {
    bool interactable = value == null;
    var style = TextStyle(color: Colors.black, fontSize: 30);
    return DragTarget<DraggableNumberInfo>(
      builder: (BuildContext context, List<DraggableNumberInfo> incoming,
          List rejected) {
        Widget child;
        if (interactable) {
          if (numbers == null) numbers = [];
          if (numbers.length == 0) {
            child = Center(child: Text('___________'));
          } else {
            var i = 0;
            child = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: numbers.map((number) {
                number.index = i++;
                return DraggableNumber(number: number);
              }).toList(),
            );
          }
        } else {
          var i = 0;
          child = Center(
              child: Text(
            '$value',
            style: style,
          ));
        }
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: Container(
            color: Colors.purple.withAlpha(35),
            child: child,
            height: radius * 2,
            width: radius * 2,
          ),
        );
      },
      onWillAccept: (number) {
        if (!interactable) return false;
        if (number.index != null) {
          _plyr.play('uhOhBaby.mp3');
          return false;
        }
        var accept = numbers.length + 1 <= _maxDigits;
        if (!accept) _plyr.play('error.mp3');
        return accept;
      },
      onAccept: (number) {
        print("Dragging in: ${number.emoji}");
        setState(() {
          numbers.add(DraggableNumberInfo.from(number));
          checkAnswer();
        });
      },
      onLeave: (number) {
        if (!interactable) return;
        if (numbers.length == 0) return;
        var i = number.index;
        if (i == null) return;
        var emoji = number.emoji;
        if (numbers.length <= i) return;
        if (numbers[i].emoji != emoji) return;
        print("Dragging out: $emoji at index $i");
        setState(() {
          numbers.removeAt(i);
          checkAnswer();
        });
      },
    );
  }

  int getValue(int a, List<DraggableNumberInfo> numbers) {
    var v = a;
    if (v == null) {
      if (numbers == null || numbers.length == 0) {
        v = 0;
      } else {
        var str = "";
        numbers.forEach((number) => str += "${number.value}");
        v = int.parse(str);
      }
    }
    return v;
  }

  void checkAnswer() {
    _t?.cancel();
    var a = getValue(widget.a, _numbersA);
    var b = getValue(widget.b, _numbersB);
    var c = getValue(widget.c, _numbersC);
    bool correct = (a + b) == c;
    print(
        "Checking answer: ${widget.a} + ${widget.b} ${correct ? "=" : "/="} $c");
    if (correct) {
      print("answer is correct!!");
      _plyr.play('success.mp3');
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _numbersA = [];
          _numbersB = [];
          _numbersC = [];
          if (widget.onOk != null) widget.onOk();
        });
      });
    } else {
      _t = Timer(Duration(seconds: 5), () {
        _plyr.play("error.mp3");
        setState(() {
          _numbersA = [];
          _numbersB = [];
          _numbersC = [];
        });
      });
    }
  }
}
