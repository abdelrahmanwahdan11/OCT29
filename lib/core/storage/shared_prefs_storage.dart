import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get instance {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('SharedPrefsStorage not initialised');
    }
    return prefs;
  }

  Future<void> setString(String key, String value) async {
    await instance.setString(key, value);
  }

  String? getString(String key) => instance.getString(key);

  Future<void> setBool(String key, bool value) async {
    await instance.setBool(key, value);
  }

  bool? getBool(String key) => instance.getBool(key);

  Future<void> setStringList(String key, List<String> value) async {
    await instance.setStringList(key, value);
  }

  List<String>? getStringList(String key) => instance.getStringList(key);
}
