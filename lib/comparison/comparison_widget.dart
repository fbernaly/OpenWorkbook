import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:audioplayers/audio_cache.dart';

import 'package:flutter_app/draggable/operation.dart';

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
  List<DraggableOperationsInfo> numbers = [];
  final int _maxDigits = 1;
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
        _buildDragTarget(),
        SizedBox(width: 8),
        Text(
          '${widget.b}',
          style: style,
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDragTarget() {
    return DragTarget<DraggableOperationsInfo>(
      builder: (BuildContext context, List<DraggableOperationsInfo> incoming,
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
              return DraggableOperation(number: number);
            }).toList(),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            color: Colors.purple.withAlpha(35),
            child: child,
            height: 80,
            width: 150,
          ),
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
        print("Dragging in: ${number.value}");
        setState(() {
          numbers.add(DraggableOperationsInfo.from(number));
          checkAnswer();
        });
      },
      onLeave: (number) {
        if (numbers.length == 0) return;
        var i = number.index;
        if (i == null) return;
        var value = number.value;
        if (numbers.length <= i) return;
        if (numbers[i].value != value) return;
        print("Dragging out: $value at index $i");
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
    String symbol = numbers[0].value;
    print("symbol: $symbol");
    bool correct = false;
    if (symbol == "<") {
      correct = widget.a < widget.b;
    } else if (symbol == ">") {
      correct = widget.a > widget.b;
    } else if (symbol == "=") {
      correct = widget.a == widget.b;
    }
    print(
        "Checking answer: ${widget.a} $symbol ${widget.b} is ${correct ? "correct" : "incorrect"} ");
    if (correct) {
      _plyr.play('success.mp3');
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          numbers = [];
          if (widget.onOk != null) widget.onOk();
        });
      });
    } else {
      t = Timer(Duration(milliseconds: 500), () {
        _plyr.play("error.mp3");
        setState(() {
          numbers = [];
        });
      });
    }
  }
}
