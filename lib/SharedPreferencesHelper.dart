import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final _highestAvailLevel = "hal";
  static final _isMusicEnabled = "isMusicEnabled";
  static final _isSoundEnabled = "isSoundEnabled";
  static final _isHintAvail = "hint";

  static Future<bool> setHighestAvailLevel(int level) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_highestAvailLevel, level);
  }

  static Future<bool> setIsHintAvail(int level, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isHintAvail+level.toString(), value);
  }

  static Future<int> getHighestAvailLevel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highestAvailLevel) ?? 1;
  }

  static Future<bool> getIsHintAvail(int level) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isHintAvail+level.toString()) ?? false;
  }

  static Future<bool> getIsMusicEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isMusicEnabled) ?? true;
  }

  static Future<bool> getIsSoundEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isSoundEnabled) ?? true;
  }
}