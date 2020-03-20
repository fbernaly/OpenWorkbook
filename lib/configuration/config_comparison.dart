import 'package:shared_preferences/shared_preferences.dart';

class ConfigComparison {
  int _min, _max;

  static final String _minKey = "config_comparison_min";
  static final String _maxKey = "config_comparison_max";

  int get min => _min;

  set min(int value) {
    if (value != _min) {
      _min = value;
      _saveInt(_minKey, _min);
    }
  }

  int get max => _max;

  set max(int value) {
    if (value != _max) {
      _max = value;
      _saveInt(_maxKey, _max);
    }
  }

  static final ConfigComparison _singleton = ConfigComparison._internal();

  factory ConfigComparison() {
    return _singleton;
  }

  ConfigComparison._internal() {
    _read();
  }

  static void start() {
    _singleton._read();
  }

  void _read() async {
    final prefs = await SharedPreferences.getInstance();
    _min = prefs.getInt(_minKey) ?? 10;
    _max = prefs.getInt(_maxKey) ?? 20;
  }

  void _saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  @override
  String toString() {
    return """
    min: $min, max: $max""";
  }
}
