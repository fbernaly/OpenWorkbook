import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DraggableNumberInfo {
  String emoji;
  int value;
  int index;

  DraggableNumberInfo({this.emoji, this.value, this.index});

  DraggableNumberInfo.from(DraggableNumberInfo info) {
    this.emoji = info.emoji;
    this.value = info.value;
    this.index = info.index;
  }
}

class DraggableNumber extends StatelessWidget {
  DraggableNumber({Key key, this.number}) : super(key: key);

  final DraggableNumberInfo number;

  static List<DraggableNumber> getNumbers() {
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
    return numbers.keys.map((emoji) {
      int value = numbers[emoji];
      var number = DraggableNumberInfo(emoji: emoji, value: value);
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
      child: Text(
        number.emoji,
        style: TextStyle(color: Colors.black, fontSize: 30),
      ),
    );
  }
}
