import 'package:shared_preferences/shared_preferences.dart';

import 'AppConstants.dart';

class UserSessionManager {
  static final UserSessionManager _instance = UserSessionManager._internal();

  factory UserSessionManager() => _instance;

  UserSessionManager._internal();

  SharedPreferences? _prefs;

  // Session variables
  String token = '';
  String userName = '';
  String mobile = '';

  bool get isInitialized => _prefs != null;

  // Optional: helper getters
  String getToken() => token;
  Future<void> clearPref() async {
    _prefs ??= await SharedPreferences.getInstance();

    await _prefs!.clear();
  }
  Future<void> sanitizePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();

  }

}
