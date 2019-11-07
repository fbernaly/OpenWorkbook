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
