import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/utils/math_operation.dart';

class ConfigAddition {
  int _minA, _minB, _maxA, _maxB;
  List<MathOperation> _operations = [MathOperation.addition];

  static final String _minAKey = "config_addition_min_a";
  static final String _minBKey = "config_addition_min_b";
  static final String _maxAKey = "config_addition_max_a";
  static final String _maxBKey = "config_addition_max_b";
  static final String _opersationsKey = "config_addition_opersations";

  int get minA => _minA;

  set minA(int value) {
    if (value != _minA) {
      _minA = value;
      _saveInt(_minAKey, _minA);
    }
  }

  int get minB => _minB;

  set minB(int value) {
    if (value != _minB) {
      _minB = value;
      _saveInt(_minBKey, _minB);
    }
  }

  int get maxA => _maxA;

  set maxA(int value) {
    if (value != _maxA) {
      _maxA = value;
      _saveInt(_maxAKey, _maxA);
    }
  }

  int get maxB => _maxB;

  set maxB(int value) {
    if (value != _maxB) {
      _maxB = value;
      _saveInt(_maxBKey, _maxB);
    }
  }

  List<MathOperation> get operations => _operations;

  set operations(List<MathOperation> value) {
    if (value != operations) {
      _operations = value;
      _saveList(_opersationsKey, _operations);
    }
  }

  static final ConfigAddition _singleton = ConfigAddition._internal();

  factory ConfigAddition() {
    return _singleton;
  }

  ConfigAddition._internal() {
    _read();
  }

  static void start() {
    _singleton._read();
  }

  void _read() async {
    final prefs = await SharedPreferences.getInstance();
    _minA = prefs.getInt(_minAKey) ?? 10;
    _maxA = prefs.getInt(_maxAKey) ?? 20;
    _minB = prefs.getInt(_minBKey) ?? 0;
    _maxB = prefs.getInt(_maxBKey) ?? 9;
    _operations = [];
    var list = prefs.getStringList(_opersationsKey) ?? [];
    list.forEach((element) {
      var i = int.parse(element);
      var operation = MathOperation.values[i];
      _operations.add(operation);
    });
    if (_operations.length == 0) _operations = [MathOperation.addition];
  }

  void _saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  void _saveList(String key, List<MathOperation> value) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = [];
    value.forEach((element) {
      list.add(element.index.toString());
    });
    prefs.setStringList(key, list);
  }

  @override
  String toString() {
    return """
    minA: $minA, maxA: $maxA
    minB: $minB, maxB: $maxB
    operations: $operations""";
  }
}
