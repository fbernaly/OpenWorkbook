import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:tuple/tuple.dart';

import 'package:flutter_app/addition/addition_page.dart';
import 'package:flutter_app/number_bond/number_bond_page.dart';
import 'package:flutter_app/comparison/comparison_page.dart';
import 'package:flutter_app/utils/force_orientation.dart';
import 'package:flutter_app/utils/random.dart';
import 'package:flutter_app/widgets/robot.dart';
import 'package:flutter_app/configuration/configuration.dart';
import 'package:flutter_app/widgets/carousel.dart';

class Home extends StatefulWidget {
  Home() : super();

  final String title = "Open Workbook";

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String message;
  Timer timer;

  @override
  initState() {
    super.initState();

    Configuration.start();

    Future.delayed(const Duration(milliseconds: 1500), () {
      _showMessage("Welcome, ready to practice?");
    });
  }

  @override
  Widget build(BuildContext context) {
    ForceOrientation.setLandscape(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Carousel(
                items: _getCarouselItems(context),
              ),
            ],
          ),
          RobotWidget(
            message: message,
            onTap: () => _showMessage(_getGreetingMessage()),
          ),
        ],
      ),
    );
  }

  List<Widget> _getCarouselItems(BuildContext context) {
    List<Tuple2<String, String>> items = [
      Tuple2('addition-and-subtraction-signs.png', 'Additions & subtractions'),
      Tuple2('less-than-greater-than-signs.png', 'Comparisons'),
      Tuple2('number_bonds.png', 'Number bonds')
    ];
    return items.map((item) {
      int index = items.indexOf(item);
      return Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              _pushPage(index);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  items[index].item2,
                  style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                      fontSize: 25),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: AssetImage(items[index].item1),
                    ),
                  ),
                ),
              ],
            ),
          ));
    }).toList();
  }

  String _getGreetingMessage() {
    var message = this.message;
    do {
      message = RandomGenerator.getRandomGreetingMessage();
    } while (this.message == message);
    return message;
  }

  void _showMessage(String message) {
    setState(() {
      this.message = message;
    });
    _startHideMessageTimer();
  }

  void _startHideMessageTimer() {
    timer?.cancel();
    if (message != null) {
      timer = Timer(Duration(seconds: 4), () {
        setState(() {
          message = null;
        });
      });
    }
  }

  void _pushPage(int index) {
    if (index == 0) _showAdditionPage();
    if (index == 1) _showComparisonPage();
    if (index == 2) _showNumberBondPage();
  }

  void _showAdditionPage() {
    WidgetBuilder pageToDisplayBuilder = (_) => AdditionSubtractionPage();
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: pageToDisplayBuilder,
      ),
    );
  }

  void _showComparisonPage() {
    WidgetBuilder pageToDisplayBuilder = (_) => ComparisonPage();
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: pageToDisplayBuilder,
      ),
    );
  }

  void _showNumberBondPage() {
    WidgetBuilder pageToDisplayBuilder = (_) => NumberBondPage();
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: pageToDisplayBuilder,
      ),
    );
  }
}
