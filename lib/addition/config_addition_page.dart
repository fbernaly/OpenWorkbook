import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ConfigAdditionPage extends StatefulWidget {
  createState() => ConfigAdditionPageState();
}

class ConfigAdditionPageState
    extends State<ConfigAdditionPage> {
  double sliderValue = 0.5;
  TextEditingController textControlller;

  @override
  initState() {
    super.initState();

    textControlller = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Edit Addition/Subtraction Dojo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('1st Number'),
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Text('Min:'),
                SizedBox(width: 8),
                Flexible(
                  child: PlatformTextField(
                    keyboardType: TextInputType.number,
                    controller: textControlller,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Text('Max:'),
                SizedBox(width: 8),
                Flexible(
                  child: PlatformTextField(
                    keyboardType: TextInputType.number,
                    controller: textControlller,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text('2nd Number'),
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Text('Min:'),
                SizedBox(width: 8),
                Flexible(
                  child: PlatformTextField(
                    keyboardType: TextInputType.number,
                    controller: textControlller,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Text('Max:'),
                SizedBox(width: 8),
                Flexible(
                  child: PlatformTextField(
                    keyboardType: TextInputType.number,
                    controller: textControlller,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
