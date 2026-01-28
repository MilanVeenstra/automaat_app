import 'package:shared_preferences/shared_preferences.dart';

/// Opslag service voor app instellingen
class SettingsStorage {
  static const String _notificationsEnabledKey = 'notifications_enabled';

  /// Haal notificatie  voorkeur op
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true; // Standaard ingeschakeld
  }

  /// Stel notificatie  voorkeur in
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }
}
