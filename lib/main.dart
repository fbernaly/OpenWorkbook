import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_app/home.dart';

void main() {
  runApp(Main());
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
    final androidTheme = ThemeData(
      primarySwatch: Colors.purple,
    );

    final cupertinoTheme = CupertinoThemeData(
      primaryColor: Colors.purple,
      barBackgroundColor: Colors.purple,
      scaffoldBackgroundColor: Colors.white,
      textTheme: CupertinoTextThemeData(
        primaryColor: Colors.white,
      ),
    );

    return PlatformProvider(
      builder: (BuildContext context) => PlatformApp(
        android: (_) => MaterialAppData(
            theme: androidTheme, debugShowCheckedModeBanner: false),
        ios: (_) => CupertinoAppData(
            theme: cupertinoTheme, debugShowCheckedModeBanner: false),
        home: Home(),
      ),
    );
  }
}
