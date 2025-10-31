import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_controller.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._appController, this._prefs) {
    _catalogGrid = _prefs.getBool(_catalogGridKey) ?? false;
  }

  final AppController _appController;
  final SharedPreferences _prefs;

  static const String _catalogGridKey = 'ui.catalog.grid';

  bool _catalogGrid = false;

  ThemeMode get themeMode => _appController.themeMode;
  Color get primaryColor => _appController.primaryColor;
  Locale get locale => _appController.locale;
  bool get isCatalogGrid => _catalogGrid;

  Future<void> toggleTheme() => _appController.toggleThemeMode();

  Future<void> setThemeMode(ThemeMode mode) => _appController.setThemeMode(mode);

  Future<void> updatePrimaryColor(Color color) => _appController.setPrimaryColor(color);

  Future<void> updateLocale(Locale locale) => _appController.setLocale(locale);

  Future<void> toggleCatalogLayout() => setCatalogLayout(!_catalogGrid);

  Future<void> setCatalogLayout(bool isGrid) async {
    if (_catalogGrid == isGrid) return;
    _catalogGrid = isGrid;
    await _prefs.setBool(_catalogGridKey, _catalogGrid);
    notifyListeners();
  }
}
