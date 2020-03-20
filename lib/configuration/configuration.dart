import 'package:flutter_app/configuration/config_addition.dart';
import 'package:flutter_app/configuration/config_comparison.dart';
import 'package:flutter_app/configuration/config_number_bond.dart';

class Configuration {
  static void start() {
    ConfigAddition.start();
    ConfigComparison.start();
    ConfigNumberBond.start();
  }
}
