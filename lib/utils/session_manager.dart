import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyUsername = "username";
  static const String _keyLoginTime = "login_time";
  static const int sessionDuration = 30 * 60; // 30 min

  static Future<void> saveSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyUsername, username);
    prefs.setInt(_keyLoginTime, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<bool> isSessionActive() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTime = prefs.getInt(_keyLoginTime);
    if (loginTime == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch;
    return ((now - loginTime) / 1000) < sessionDuration;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
