import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DraggableWidget extends StatelessWidget {
  DraggableWidget({Key key, this.emoji}) : super(key: key);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: emoji,
      child: _buildDraggableWidget(),
      feedback: _buildDraggableWidget(),
      childWhenDragging: _buildDraggableWidget(),
    );
  }

  Widget _buildDraggableWidget() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Text(
        emoji,
        style: TextStyle(color: Colors.black, fontSize: 30),
      ),
    );
  }
}
