import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:audioplayers/audio_cache.dart';

import 'package:flutter_app/draggable.dart';

import 'package:flutter_app/math_operation.dart';

class AdditionWidget extends StatefulWidget {
  int a;
  int b;
  MathOperation operation;
  void Function() onOk;

  AdditionWidget({this.a, this.b, this.operation, this.onOk});

  createState() => AdditionState();
}

class AdditionState extends State<AdditionWidget> {
  List<DraggableNumberInfo> numbers = [];
  final int _maxDigits = 3;
  AudioCache _plyr = AudioCache();
  Timer t;

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(color: Colors.black, fontSize: 30);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "${widget.a}",
          style: style,
        ),
        SizedBox(width: 8),
        Text(
          _getOperationStr(),
          style: style,
        ),
        SizedBox(width: 8),
        Text(
          '${widget.b}',
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

  String _getOperationStr() {
    if (widget.operation == MathOperation.addition) return "+";
    if (widget.operation == MathOperation.subtraction) return "-";
    return "";
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
              return DraggableNumber(number: number);
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
      onWillAccept: (number) {
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

  void checkAnswer() {
    t?.cancel();
    if (numbers.length == 0) return;
    var str = "";
    numbers.forEach((number) => str += "${number.value}");
    var answer = int.parse(str);
    String symbol = "";
    bool correct = false;
    if (widget.operation == MathOperation.addition) {
      symbol = "+";
      correct = (widget.a + widget.b) == answer;
    } else if (widget.operation == MathOperation.subtraction) {
      symbol = "-";
      correct = (widget.a - widget.b) == answer;
    }
    print(
        "Checking answer: ${widget.a} $symbol ${widget.b} ${correct ? "=" : "/="} $answer");
    if (correct) {
      print("answer is correct!!");
      _plyr.play('success.mp3');
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          numbers = [];
          if (widget.onOk != null) widget.onOk();
        });
      });
    } else {
      t = Timer(Duration(seconds: 5), () {
        _plyr.play("error.mp3");
        setState(() {
          numbers = [];
        });
      });
    }
  }
}
