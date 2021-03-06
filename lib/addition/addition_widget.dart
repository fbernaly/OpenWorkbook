import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_app/utils/audio_player.dart';
import 'package:flutter_app/widgets/number.dart';
import 'package:flutter_app/utils/math_operation.dart';

class AdditionWidget extends StatefulWidget {
  int a;
  int b;
  bool clear;
  MathOperation operation;
  void Function() onOk;
  void Function() onReview;
  void Function() onError;

  AdditionWidget(
      {this.a,
      this.b,
      this.clear,
      this.operation,
      this.onOk,
      this.onReview,
      this.onError});

  createState() => AdditionState();
}

class AdditionState extends State<AdditionWidget> {
  List<DraggableNumberInfo> numbers = [];
  final int _maxDigits = 3;
  AudioPlayer _plyr = AudioPlayer();
  Timer t;

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(color: Colors.black, fontSize: 30);
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: DraggableNumber.getNumbers(onTapNumber)),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
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
            ),
          ],
        ),
      ],
    );
  }

  String _getOperationStr() {
    if (widget.operation == MathOperation.addition) return "+";
    if (widget.operation == MathOperation.subtraction) return "-";
    return "";
  }

  Widget _buildDragTarget() {
    if (widget.clear) {
      numbers = [];
      t?.cancel();
      widget.clear = false;
    }
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
              return DraggableNumber(
                number: number,
                onTap: (number) => onTapNumber(number),
              );
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
          _plyr.playRemoveSound();
          return false;
        }
        var accept = numbers.length + 1 <= _maxDigits;
        if (!accept) _plyr.playErrorSound();
        return accept;
      },
      onAccept: (number) {
        print("Dragging in: ${number.value}");
        setState(() {
          numbers.add(DraggableNumberInfo.from(number));
          checkAnswer();
        });
      },
      onLeave: (object) {
        if (numbers.length == 0) return;
        DraggableNumberInfo number = object as DraggableNumberInfo;
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

  void onTapNumber(DraggableNumberInfo number) {
    setState(() {
      if (number.index == null && numbers.length + 1 <= _maxDigits)
        numbers.add(number);
      else if (number.index != null) numbers.removeAt(number.index);
      checkAnswer();
    });
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
      Future.delayed(const Duration(milliseconds: 250), () {
        print("answer is correct!!");
        widget?.onOk();
        _plyr.playSuccessSound();
      });
    } else {
      t = Timer(Duration(milliseconds: 1500), () {
        widget?.onReview();
        t = Timer(Duration(milliseconds: 3500), () {
          widget?.onError();
          numbers = [];
          _plyr.playErrorSound();
        });
      });
    }
  }
}
