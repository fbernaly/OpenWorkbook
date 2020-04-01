import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_app/widgets/number.dart';
import 'package:flutter_app/utils/audio_player.dart';

class NumberBondWidget extends StatefulWidget {
  int a;
  int b;
  int c;
  bool clear;
  void Function() onOk;
  void Function() onReview;
  void Function() onError;

  NumberBondWidget(
      {this.a,
      this.b,
      this.c,
      this.clear,
      this.onOk,
      this.onReview,
      this.onError});

  createState() => NumberBondState();
}

class NumberBondState extends State<NumberBondWidget> {
  List<DraggableNumberInfo> _numbersA = [], _numbersB = [], _numbersC = [];
  final int _maxDigits = 2;
  AudioPlayer _plyr = AudioPlayer();
  Timer t;

  @override
  Widget build(BuildContext context) {
    double radius = 45;
    if (widget.clear) {
      t?.cancel();
      widget.clear = false;
      if (widget.a == null) _numbersA = [];
      if (widget.b == null) _numbersB = [];
      if (widget.c == null) _numbersC = [];
    }
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
            _buildDragTarget(
                radius: radius, value: widget.c, numbers: _numbersC),
            Text('/              \\'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildDragTarget(
                    radius: radius, value: widget.a, numbers: _numbersA),
                SizedBox(width: 20),
                _buildDragTarget(
                    radius: radius, value: widget.b, numbers: _numbersB),
              ],
            ),
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
                return DraggableNumber(
                  number: number,
                  onTap: (number) => onTapNumber(number),
                );
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
        if (!interactable) return;
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

  void onTapNumber(DraggableNumberInfo number) {
    setState(() {
      if (number.index != null) {
        var i = _numbersA.indexOf(number);
        if (i >= 0) _numbersA.removeAt(i);

        i = _numbersB.indexOf(number);
        if (i >= 0) _numbersB.removeAt(i);

        i = _numbersC.indexOf(number);
        if (i >= 0) _numbersC.removeAt(i);
      } else {
        if (widget.a == null && widget.b != null && widget.c != null) {
          if (_numbersA.length + 1 <= _maxDigits) {
            _numbersA.add(number);
          }
        } else if (widget.a != null && widget.b == null && widget.c != null) {
          if (_numbersB.length + 1 <= _maxDigits) {
            _numbersB.add(number);
          }
        } else if (widget.a != null && widget.b != null && widget.c == null) {
          if (_numbersC.length + 1 <= _maxDigits) {
            _numbersC.add(number);
          }
        }
      }
      checkAnswer();
    });
  }

  void checkAnswer() {
    t?.cancel();
    var a = getValue(widget.a, _numbersA);
    var b = getValue(widget.b, _numbersB);
    var c = getValue(widget.c, _numbersC);
    bool correct = (a + b) == c;
    print(
        "Checking answer: ${widget.a} + ${widget.b} ${correct ? "=" : "/="} $c");
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
          _numbersA = [];
          _numbersB = [];
          _numbersC = [];
          _plyr.playErrorSound();
        });
      });
    }
  }
}
