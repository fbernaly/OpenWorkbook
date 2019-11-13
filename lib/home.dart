import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'dart:io' show Platform;

import 'package:flutter_app/addition/addition_page.dart';
import 'package:flutter_app/number_bond/number_bond_page.dart';
import 'package:flutter_app/force_orientation.dart';

class Home extends StatefulWidget {
  Home() : super();

  final String title = "Open Workbook";

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  CarouselSlider carouselSlider;
  int _current = 0;
  List imgList = [
    'addition-and-subtraction-signs.png',
    'less-than-greater-than-signs.png',
    'number_bonds.png'
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    ForceOrientation.setLandscape(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: Platform.isIOS ? 60 : 10),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: carouselSlider = _getCarouselSlider(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(imgList, (index, url) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Colors.purple
                        : Colors.purple.withAlpha(100),
                  ),
                );
              }),
            ),
            SizedBox(height: Platform.isIOS ? 10 : 0),
          ],
        ),
      ),
    );
  }

  CarouselSlider _getCarouselSlider() {
    return CarouselSlider(
      viewportFraction: 0.7,
      aspectRatio: 1.0,
      enlargeCenterPage: true,
      autoPlay: true,
      reverse: false,
      enableInfiniteScroll: true,
      autoPlayInterval: Duration(seconds: 2),
      autoPlayAnimationDuration: Duration(milliseconds: 2000),
      pauseAutoPlayOnTouch: Duration(seconds: 3),
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },
      items: imgList.map((imgName) {
        return InkWell(
          onTap: () {
            int i = imgList.indexOf(imgName);
            _pushPage(i);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Image(
                image: AssetImage(imgName),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _pushPage(int index) {
    print("Push page $index");
    if (_current != index) carouselSlider.jumpToPage(index);
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

  void _showComparisonPage() {}

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
