import 'package:shared_preferences/shared_preferences.dart';

class ConfigNumberBond {
  int _min, _max;

  static final String _minKey = "config_number_bond_min";
  static final String _maxKey = "config_number_bond_max";

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

  static final ConfigNumberBond _singleton = ConfigNumberBond._internal();

  factory ConfigNumberBond() {
    return _singleton;
  }

  ConfigNumberBond._internal() {
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
