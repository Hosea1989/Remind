import 'package:shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static const String _darkModeKey = 'darkMode';
  static const String _notificationsKey = 'notifications';
  static const String _languageKey = 'language';

  late final SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isDarkMode => _prefs.getBool(_darkModeKey) ?? false;
  bool get notificationsEnabled => _prefs.getBool(_notificationsKey) ?? true;
  String get language => _prefs.getString(_languageKey) ?? 'en';

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_darkModeKey, value);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_notificationsKey, value);
  }

  Future<void> setLanguage(String value) async {
    await _prefs.setString(_languageKey, value);
  }
} 