import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'draggable.dart';
import 'target.dart';

class Home extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text('Open Workbook'),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: numbers.keys.map((emoji) {
                  return DraggableWidget(emoji: emoji);
                }).toList()),
            Expanded(
              child: TargetWidget(),
            ),
          ],
        ));
  }
}
