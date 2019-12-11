import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DraggableNumberInfo {
  int value;
  int index;

  DraggableNumberInfo({this.value, this.index});

  DraggableNumberInfo.from(DraggableNumberInfo info) {
    this.value = info.value;
    this.index = info.index;
  }
}

class DraggableNumber extends StatelessWidget {
  DraggableNumber({Key key, this.number}) : super(key: key);

  final DraggableNumberInfo number;

  static List<DraggableNumber> getNumbers() {
    /// Choices for game
    final List<int> numbers = [
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
    ];
    return numbers.map((value) {
      var number = DraggableNumberInfo(value: value);
      return DraggableNumber(number: number);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<DraggableNumberInfo>(
      data: number,
      child: _buildDraggableWidget(),
      feedback: _buildDraggableWidget(),
      childWhenDragging: _buildDraggableWidget(),
    );
  }

  Widget _buildDraggableWidget() {
    return Container(
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: Colors.purple.withAlpha(35),
        border: Border.all(color: Colors.purple.withAlpha(85), width: 3.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Center(
        child: Text(
          "${number.value}",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      height: 40,
      width: 40,
    );
  }
}
