import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'dart:io' show Platform;

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_app/force_orientation.dart';

class ConfigNumberBond {
  int min = 10, max = 20;

  @override
  String toString() {
    return """
    min: $min, max: $max""";
  }
}

class ConfigNumberBondPage extends StatefulWidget {
  ConfigNumberBond config;

  ConfigNumberBondPage(this.config);

  createState() => ConfigNumberBondPageState();
}

class ConfigNumberBondPageState extends State<ConfigNumberBondPage> {
  TextEditingController textControlllerMin;
  TextEditingController textControlllerMax;

  @override
  initState() {
    super.initState();

    textControlllerMin = TextEditingController(text: "${widget.config.min}");
    textControlllerMax = TextEditingController(text: "${widget.config.max}");
  }

  @override
  void dispose() {
    // update config
    widget.config.min = int.parse(textControlllerMin.text);
    widget.config.max = int.parse(textControlllerMax.text);

    // Clean up the controller when the widget is disposed.
    textControlllerMin.dispose();
    textControlllerMax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ForceOrientation.setPortrait(context);
    var textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Configure Number Bond Dojo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: Platform.isIOS ? 100 : 0),
            Text('Number bond', style: textStyle),
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Text('Min:'),
                SizedBox(width: 8),
                Flexible(
                  child: PlatformTextField(
                    keyboardType: TextInputType.number,
                    controller: textControlllerMin,
                  ),
                ),
                SizedBox(width: 20),
                Text('Max:'),
                SizedBox(width: 8),
                Flexible(
                  child: PlatformTextField(
                    keyboardType: TextInputType.number,
                    controller: textControlllerMax,
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
