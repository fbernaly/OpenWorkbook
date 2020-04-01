import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  List<Widget> items;

  Carousel({Key key, this.items}) : super(key: key);

  createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  int _current = 0;

  List<T> _map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: CarouselSlider(
                items: widget.items,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                pauseAutoPlayOnTouch: Duration(seconds: 5),
                onPageChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _map<Widget>(widget.items, (index, url) {
              return Container(
                width: 8.0,
                height: 8.0,
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
          SizedBox(
            height: 10,
          ),
        ])));
  }
}
