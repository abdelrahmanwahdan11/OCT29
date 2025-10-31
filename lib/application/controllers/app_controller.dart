import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';

class AppController extends ChangeNotifier {
  AppController(this._prefs) {
    _restore();
  }

  final SharedPreferences _prefs;

  static const _themeKey = 'app.theme.mode';
  static const _primaryColorKey = 'app.theme.primary';
  static const _localeKey = 'app.locale';
  static const _userKey = 'app.user';
  static const _onboardingKey = 'seen.onboarding';

  ThemeMode _themeMode = ThemeMode.dark;
  Color _primaryColor = const Color(0xFF36E67D);
  Locale _locale = const Locale('en');
  User? _user;
  bool _hasSeenOnboarding = false;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  Locale get locale => _locale;
  User? get user => _user;
  bool get isGuest => _user?.isGuest ?? true;
  bool get isAuthenticated => _user != null && !(_user?.isGuest ?? true);
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  Future<void> toggleThemeMode() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _prefs.setString(_themeKey, _themeMode.name);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_themeKey, mode.name);
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    await _prefs.setInt(_primaryColorKey, color.value);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> setUser(User? user) async {
    _user = user;
    if (user == null) {
      await _prefs.remove(_userKey);
    } else {
      await _prefs.setString(_userKey, _encodeUser(user));
    }
    notifyListeners();
  }

  Future<void> signInAsGuest() async {
    await setUser(const User(
      id: 'guest',
      name: 'Guest',
      email: '',
      phone: '',
      avatarUrl: '',
      isGuest: true,
    ));
  }

  Future<void> completeOnboarding() async {
    if (_hasSeenOnboarding) {
      return;
    }
    _hasSeenOnboarding = true;
    await _prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }

  void _restore() {
    final storedTheme = _prefs.getString(_themeKey);
    if (storedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == storedTheme,
        orElse: () => ThemeMode.dark,
      );
    }

    final storedColor = _prefs.getInt(_primaryColorKey);
    if (storedColor != null) {
      _primaryColor = Color(storedColor);
    }

    final storedLocale = _prefs.getString(_localeKey);
    if (storedLocale != null) {
      _locale = Locale(storedLocale);
    }

    final storedUser = _prefs.getString(_userKey);
    if (storedUser != null) {
      _user = _decodeUser(storedUser);
    }

    _hasSeenOnboarding = _prefs.getBool(_onboardingKey) ?? false;

    notifyListeners();
  }

  String _encodeUser(User user) {
    return '${user.id}|${user.name}|${user.email}|${user.phone}|${user.avatarUrl}|${user.isGuest ? 1 : 0}';
  }

  User _decodeUser(String value) {
    final parts = value.split('|');
    return User(
      id: parts.elementAt(0),
      name: parts.elementAt(1),
      email: parts.elementAt(2),
      phone: parts.elementAt(3),
      avatarUrl: parts.elementAt(4),
      isGuest: parts.elementAt(5) == '1',
    );
  }
}
