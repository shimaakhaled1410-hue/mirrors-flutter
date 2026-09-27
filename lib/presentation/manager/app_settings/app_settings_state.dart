import 'package:flutter/material.dart';

class AppSettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  const AppSettingsState({
    required this.themeMode,
    required this.locale,
  });

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}