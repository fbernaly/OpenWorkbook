import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_app/addition/addition_page.dart';

void main() {
  runApp(new Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) => App();
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final themeData = new ThemeData(
      primarySwatch: Colors.purple,
    );

    final cupertinoTheme = new CupertinoThemeData(
      primaryColor: Colors.purple,
    );

    return PlatformProvider(
      builder: (BuildContext context) => PlatformApp(
        title: 'Flutter Platform Widgets',
        android: (_) => new MaterialAppData(theme: themeData),
        ios: (_) => new CupertinoAppData(theme: cupertinoTheme),
        home: AdditionSubtractionPage(),
      ),
    );
  }
}
