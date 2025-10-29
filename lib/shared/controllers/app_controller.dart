import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/storage/shared_prefs_storage.dart';

class AppController extends ChangeNotifier {
  AppController({required SharedPrefsStorage storage}) : _storage = storage;

  final SharedPrefsStorage _storage;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('ar');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  TextDirection get textDirection =>
      _locale.languageCode.toLowerCase() == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  static const _prefsKey = 'app_controller_state';

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _persist();
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _persist();
    notifyListeners();
  }

  void bootstrap() {
    final data = _storage.getString(_prefsKey);
    if (data == null) return;
    try {
      final payload = jsonDecode(data) as Map<String, dynamic>;
      final theme = payload['theme'] as String?;
      final locale = payload['locale'] as String?;
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == theme,
        orElse: () => ThemeMode.system,
      );
      if (locale != null) {
        _locale = Locale(locale);
      }
    } catch (_) {
      // ignore corrupted state
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final next = switch (_themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setThemeMode(next);
  }

  Future<void> cycleLocale() async {
    final next = _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    await setLocale(next);
  }

  Future<void> _persist() async {
    final payload = jsonEncode({
      'theme': _themeMode.name,
      'locale': _locale.languageCode,
    });
    await _storage.setString(_prefsKey, payload);
  }
}
