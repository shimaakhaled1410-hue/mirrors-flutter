import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirrors_app/presentation/manager/app_settings/app_settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  static const String _themeKey = 'app_theme_mode';
  static const String _localeKey = 'app_locale';

  final SharedPreferences _prefs;

  AppSettingsCubit(this._prefs)
    : super(
        AppSettingsState(
          themeMode: _loadInitialTheme(_prefs),
          locale: _loadInitialLocale(_prefs),
        ),
      );

  static ThemeMode _loadInitialTheme(SharedPreferences prefs) {
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex == null) return ThemeMode.system;
    return ThemeMode.values[themeIndex];
  }

  static Locale _loadInitialLocale(SharedPreferences prefs) {
    final languageCode = prefs.getString(_localeKey);
    if (languageCode == null) return const Locale('ar'); // Default to Arabic
    return Locale(languageCode);
  }

  Future<void> toggleTheme(bool isDark) async {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _prefs.setInt(_themeKey, mode.index);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> changeLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
    emit(state.copyWith(locale: locale));
  }
}
