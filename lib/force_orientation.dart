import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class ForceOrientation {
  static const _rotationChannel =
      const MethodChannel('com.openworkbook.orientation');

  static void setLandscape(BuildContext context) {
    if (ModalRoute.of(context).isCurrent) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      try {
        _rotationChannel.invokeMethod('setLandscape');
      } catch (error) {}
    }
  }

  static void setPortrait(BuildContext context) {
    if (ModalRoute.of(context).isCurrent) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      try {
        _rotationChannel.invokeMethod('setPortrait');
      } catch (error) {}
    }
  }
}
