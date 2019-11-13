import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:audioplayers/audio_cache.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'dart:io' show Platform;

import 'package:flutter_app/number_bond/number_bond_widget.dart';
import 'package:flutter_app/number_bond/config_number_bond_page.dart';
import 'package:flutter_app/draggable/number.dart';
import 'package:flutter_app/force_orientation.dart';
import 'package:flutter_app/random.dart';

class NumberBondPage extends StatefulWidget {
  String title = "Number Bond Dojo";

  createState() => NumberBondState();
}

class NumberBondState extends State<NumberBondPage> {
  int a, b, c;
  ConfigNumberBond config = ConfigNumberBond();
  AudioCache _plyr = AudioCache();

  @override
  initState() {
    super.initState();

    _setOperation();
  }

  @override
  Widget build(BuildContext context) {
    ForceOrientation.setLandscape(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.title),
        trailingActions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _config(),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: Platform.isIOS ? 60 : 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: DraggableNumber.getNumbers()),
              Expanded(
                child: NumberBondWidget(
                  a: a,
                  b: b,
                  onOk: () => _onOk(),
                ),
              ),
            ],
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: PlatformIconButton(
                onPressed: () => _reload(),
                iosIcon: Icon(
                  CupertinoIcons.refresh,
                  size: 35.0,
                ),
                androidIcon: Icon(Icons.refresh, size: 35.0)),
          )
        ],
      ),
    );
  }

  void _config() {
    WidgetBuilder pageToDisplayBuilder = (_) => ConfigNumberBondPage(config);
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: pageToDisplayBuilder,
      ),
    );
  }

  void _onOk() {
    setState(() {
      _setOperation();
    });
  }

  void _reload() {
    _plyr.play('swoosh.mp3');
    setState(() {
      _setOperation();
    });
  }

  void _setOperation() {
    var a = this.a;
    do {
      a = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch,
          min: config.min,
          max: config.max);
    } while (this.a == a);
    this.a = a;
    var b = this.b;
    do {
      b = RandomGenerator.generate(
          seed: DateTime.now().millisecondsSinceEpoch + 1,
          min: config.min,
          max: config.max);
    } while (this.b == b);
    this.b = b;
    print("new operation: $a + $b");
  }
}
