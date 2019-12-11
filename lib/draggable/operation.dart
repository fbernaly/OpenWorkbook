import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DraggableOperationsInfo {
  String value;
  int index;

  DraggableOperationsInfo({this.value, this.index});

  DraggableOperationsInfo.from(DraggableOperationsInfo info) {
    this.value = info.value;
    this.index = info.index;
  }
}

class DraggableOperation extends StatelessWidget {
  DraggableOperation({Key key, this.number}) : super(key: key);

  final DraggableOperationsInfo number;

  static List<DraggableOperation> getOperations() {
    /// Choices for game
    final List<String> numbers = [
      "<",
      "=",
      ">",
    ];
    return numbers.map((value) {
      var number = DraggableOperationsInfo(value: value);
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
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: Colors.purple.withAlpha(35),
        border: Border.all(color: Colors.purple.withAlpha(85), width: 3.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Center(
        child: Text(
          number.value,
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      height: 40,
      width: 40,
    );
  }
}
