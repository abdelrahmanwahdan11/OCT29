import 'package:flutter/material.dart';

import 'app_controller.dart';

class SettingsController {
  SettingsController(this._appController);

  final AppController _appController;

  ThemeMode get themeMode => _appController.themeMode;
  Color get primaryColor => _appController.primaryColor;
  Locale get locale => _appController.locale;

  Future<void> toggleTheme() => _appController.toggleThemeMode();

  Future<void> setThemeMode(ThemeMode mode) => _appController.setThemeMode(mode);

  Future<void> updatePrimaryColor(Color color) => _appController.setPrimaryColor(color);

  Future<void> updateLocale(Locale locale) => _appController.setLocale(locale);
}
