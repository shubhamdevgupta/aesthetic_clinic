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


/*  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    token = _prefs?.getString(AppConstants.prefToken) ?? '';
    userName = _prefs?.getString(AppConstants.prefName) ?? '';
    mobile = _prefs?.getString(AppConstants.prefMobile) ?? '';

  }*/

  bool get isInitialized => _prefs != null;

  // Optional: helper getters
  String getToken() => token;
  int getUserId() => int.tryParse(_prefs?.getString(AppConstants.prefRegId) ?? '0') ?? 0;
  Future<void> clearPref() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(AppConstants.prefRegId);
    await _prefs!.remove(AppConstants.prefRoleId);

    await _prefs!.clear(); // Optionally clear all
  }
  Future<void> sanitizePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();

    // Check for corrupt data and remove it
    if (_prefs!.get(AppConstants.prefRegId) is String) {
      await _prefs!.remove(AppConstants.prefRegId);
    }

    if (_prefs!.get(AppConstants.prefRoleId) is String) {
      await _prefs!.remove(AppConstants.prefRoleId);
    }


  }

}
