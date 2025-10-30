import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  AppState._(this._prefs) {
    _themeMode = _readThemeMode();
    _locale = _readLocale();
    _onboardingDone = _prefs.getBool(_onboardingKey) ?? false;
    _loggedIn = _prefs.getBool(_loggedInKey) ?? false;
    _isGuest = _prefs.getBool(_isGuestKey) ?? false;
    _email = _prefs.getString(_emailKey);
  }

  static const _themeModeKey = 'themeMode';
  static const _localeKey = 'locale';
  static const _onboardingKey = 'onboardingDone';
  static const _loggedInKey = 'loggedIn';
  static const _isGuestKey = 'isGuest';
  static const _emailKey = 'email';

  final SharedPreferences _prefs;

  late ThemeMode _themeMode;
  late Locale _locale;
  late bool _onboardingDone;
  late bool _loggedIn;
  late bool _isGuest;
  String? _email;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get onboardingDone => _onboardingDone;
  bool get loggedIn => _loggedIn;
  bool get isGuest => _isGuest;
  String? get email => _email;

  static Future<AppState> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return AppState._(prefs);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_themeModeKey, mode.name);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!['ar', 'en'].contains(locale.languageCode)) {
      return;
    }
    _locale = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    await _prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }

  Future<void> login({required String email}) async {
    _email = email;
    _loggedIn = true;
    _isGuest = false;
    await Future.wait([
      _prefs.setString(_emailKey, email),
      _prefs.setBool(_loggedInKey, true),
      _prefs.setBool(_isGuestKey, false),
    ]);
    notifyListeners();
  }

  Future<void> signup({required String email}) async {
    await login(email: email);
  }

  Future<void> loginAsGuest() async {
    _isGuest = true;
    _loggedIn = false;
    _email = null;
    await Future.wait([
      _prefs.setBool(_isGuestKey, true),
      _prefs.setBool(_loggedInKey, false),
      _prefs.remove(_emailKey),
    ]);
    notifyListeners();
  }

  Future<void> logout() async {
    _loggedIn = false;
    _isGuest = false;
    _email = null;
    await Future.wait([
      _prefs.setBool(_loggedInKey, false),
      _prefs.setBool(_isGuestKey, false),
      _prefs.remove(_emailKey),
    ]);
    notifyListeners();
  }

  ThemeMode _readThemeMode() {
    final value = _prefs.getString(_themeModeKey);
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  Locale _readLocale() {
    final code = _prefs.getString(_localeKey) ?? 'ar';
    return Locale(code);
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static AppState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}
