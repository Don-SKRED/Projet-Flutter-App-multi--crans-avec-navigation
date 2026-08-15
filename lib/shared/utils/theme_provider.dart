import 'package:flutter/material.dart';

import 'package:multi_screen_app_with_navigation/shared/services/preference_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider({PreferenceService? preferenceService})
    : preferences = preferenceService ?? PreferenceService();

  final PreferenceService preferences;
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  Future currentMode() async {
    bool isDark = await preferences.readFile();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future changeMode(bool value) async {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    await preferences.save(value);
    notifyListeners();
  }
}

final themeProvider = ThemeProvider();
