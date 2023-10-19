import 'package:shared_preferences/shared_preferences.dart';

enum SharedKeys { monday, tuesday, wednesday, thursday, friday, date }

class SharedManager {
  SharedPreferences? preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  void _checkPreferences() {
    if (preferences == null) throw 'SharedNotInitializeException';
  }

  Future<void> saveStringItem(SharedKeys key, String value) async {
    _checkPreferences();
    await preferences?.setString(key.name, value);
  }

  String? getStringItem(SharedKeys key) {
    _checkPreferences();
    return preferences?.getString(key.name);
  }

  Future<void> saveStringItems(SharedKeys key, List<String> value) async {
    _checkPreferences();
    await preferences?.setStringList(key.name, value);
  }

  List<String>? getStringItems(SharedKeys key) {
    _checkPreferences();
    return preferences?.getStringList(key.name);
  }

  Future<bool> removeItem(SharedKeys key) async {
    _checkPreferences();
    return (await preferences?.remove(key.name)) ?? false;
  }

  bool hasKey(SharedKeys key) {
    _checkPreferences();
    return (preferences?.containsKey(key.name) ?? false);
  }
}
