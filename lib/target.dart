import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TargetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '1',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        SizedBox(width: 8),
        Text(
          '+',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        SizedBox(width: 8),
        Text(
          '3',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        SizedBox(width: 8),
        Text(
          '=',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        SizedBox(width: 8),
        _buildDragTarget(),
      ],
    );
  }

  Widget _buildDragTarget() {
    return DragTarget<String>(
      builder: (BuildContext context, List<String> incoming, List rejected) {
        return Container(
          color: Colors.grey,
          child: Text('Here'),
          alignment: Alignment.center,
          height: 80,
          width: 200,
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        print(data);
      },
      onLeave: (data) {},
    );
  }
}
