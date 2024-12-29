import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/services/settings_service.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsState {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String language;

  SettingsState({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.language,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? language,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(SettingsState(
          isDarkMode: false,
          notificationsEnabled: true,
          language: 'en',
        )) {
    _loadSettings();
  }

  final _settingsService = SettingsService();

  Future<void> _loadSettings() async {
    state = SettingsState(
      isDarkMode: _settingsService.isDarkMode,
      notificationsEnabled: _settingsService.notificationsEnabled,
      language: _settingsService.language,
    );
  }

  Future<void> toggleDarkMode() async {
    await _settingsService.setDarkMode(!state.isDarkMode);
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  Future<void> toggleNotifications() async {
    await _settingsService.setNotificationsEnabled(!state.notificationsEnabled);
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
  }

  Future<void> setLanguage(String language) async {
    await _settingsService.setLanguage(language);
    state = state.copyWith(language: language);
  }
} 