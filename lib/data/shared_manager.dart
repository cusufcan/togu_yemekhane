import 'package:shared_preferences/shared_preferences.dart';

enum SharedKeysGOP {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  dateGop,
  mondayHO,
  tuesdayHO,
  wednesdayHO,
  thursdayHO,
  fridayHO,
  saturdayHO,
  sundayHO,
  mondayAO,
  tuesdayAO,
  wednesdayAO,
  thursdayAO,
  fridayAO,
  saturdayAO,
  sundayAO,
  dateHospital,
}

class SharedManager {
  SharedPreferences? preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  void _checkPreferences() {
    if (preferences == null) throw 'SharedNotInitializeException';
  }

  Future<void> saveStringItem(SharedKeysGOP key, String value) async {
    _checkPreferences();
    await preferences?.setString(key.name, value);
  }

  String? getStringItem(SharedKeysGOP key) {
    _checkPreferences();
    return preferences?.getString(key.name);
  }

  Future<void> saveStringItems(SharedKeysGOP key, List<String> value) async {
    _checkPreferences();
    await preferences?.setStringList(key.name, value);
  }

  List<String>? getStringItems(SharedKeysGOP key) {
    _checkPreferences();
    return preferences?.getStringList(key.name);
  }

  Future<bool> removeItem(SharedKeysGOP key) async {
    _checkPreferences();
    return (await preferences?.remove(key.name)) ?? false;
  }

  bool hasKey(SharedKeysGOP key) {
    _checkPreferences();
    return (preferences?.containsKey(key.name) ?? false);
  }
}
