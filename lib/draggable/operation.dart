import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DraggableOperationsInfo {
  String emoji;
  int value;
  int index;

  DraggableOperationsInfo({this.emoji, this.value, this.index});

  DraggableOperationsInfo.from(DraggableOperationsInfo info) {
    this.emoji = info.emoji;
    this.value = info.value;
    this.index = info.index;
  }
}

class DraggableOperation extends StatelessWidget {
  DraggableOperation({Key key, this.number}) : super(key: key);

  final DraggableOperationsInfo number;

  static List<DraggableOperation> getOperations() {
    /// Choices for game
    final Map numbers = {
      '<⃣': 0,
      '=⃣': 1,
      '>⃣': 2,
    };
    return numbers.keys.map((emoji) {
      int value = numbers[emoji];
      var number = DraggableOperationsInfo(emoji: emoji, value: value);
      return DraggableOperation(number: number);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<DraggableOperationsInfo>(
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
