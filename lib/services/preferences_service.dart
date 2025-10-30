import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/collection.dart';

enum StoredThemeMode { system, light, dark }

class PreferencesKeys {
  static const hasSeenOnboarding = 'prefs.hasSeenOnboarding';
  static const themeMode = 'prefs.themeMode';
  static const locale = 'prefs.locale';
  static const favorites = 'prefs.favorites';
  static const guestSession = 'prefs.guestSession';
  static const searchHistory = 'prefs.searchHistory';
  static const recentlyViewed = 'prefs.recentlyViewed';
  static const feedLayout = 'prefs.feedLayout';
  static const savedSearches = 'prefs.savedSearches';
  static const filtersState = 'prefs.filtersState';
  static const sortState = 'prefs.sortState';
  static const collections = 'prefs.collections';
  static const compareSelection = 'prefs.compareSelection';
}

class PreferencesService {
  PreferencesService(this._preferences);

  final SharedPreferences _preferences;

  static Future<PreferencesService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  bool getHasSeenOnboarding() {
    return _preferences.getBool(PreferencesKeys.hasSeenOnboarding) ?? false;
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    await _preferences.setBool(PreferencesKeys.hasSeenOnboarding, value);
  }

  StoredThemeMode getThemeMode() {
    final value = _preferences.getString(PreferencesKeys.themeMode);
    switch (value) {
      case 'light':
        return StoredThemeMode.light;
      case 'dark':
        return StoredThemeMode.dark;
      default:
        return StoredThemeMode.system;
    }
  }

  Future<void> setThemeMode(StoredThemeMode mode) async {
    final value = switch (mode) {
      StoredThemeMode.system => 'system',
      StoredThemeMode.light => 'light',
      StoredThemeMode.dark => 'dark',
    };
    await _preferences.setString(PreferencesKeys.themeMode, value);
  }

  String? getStoredLocaleCode() {
    return _preferences.getString(PreferencesKeys.locale);
  }

  Future<void> setLocaleCode(String languageCode) async {
    await _preferences.setString(PreferencesKeys.locale, languageCode);
  }

  Set<String> getFavorites() {
    final list = _preferences.getStringList(PreferencesKeys.favorites) ?? <String>[];
    return list.toSet();
  }

  Future<void> setFavorites(Set<String> ids) async {
    await _preferences.setStringList(PreferencesKeys.favorites, ids.toList());
  }

  bool isGuestSession() {
    return _preferences.getBool(PreferencesKeys.guestSession) ?? false;
  }

  Future<void> setGuestSession(bool value) async {
    await _preferences.setBool(PreferencesKeys.guestSession, value);
  }

  List<String> getSearchHistory() {
    return _preferences.getStringList(PreferencesKeys.searchHistory) ?? <String>[];
  }

  Future<void> setSearchHistory(List<String> history) async {
    await _preferences.setStringList(PreferencesKeys.searchHistory, history);
  }

  List<String> getRecentlyViewed() {
    return _preferences.getStringList(PreferencesKeys.recentlyViewed) ?? <String>[];
  }

  Future<void> setRecentlyViewed(List<String> ids) async {
    await _preferences.setStringList(PreferencesKeys.recentlyViewed, ids);
  }

  String getFeedLayout() {
    return _preferences.getString(PreferencesKeys.feedLayout) ?? 'grid';
  }

  Future<void> setFeedLayout(String layout) async {
    await _preferences.setString(PreferencesKeys.feedLayout, layout);
  }

  List<String> getSavedSearches() {
    return _preferences.getStringList(PreferencesKeys.savedSearches) ?? <String>[];
  }

  Future<void> setSavedSearches(List<String> searches) async {
    await _preferences.setStringList(PreferencesKeys.savedSearches, searches);
  }

  Map<String, dynamic> getFiltersState() {
    final raw = _preferences.getString(PreferencesKeys.filtersState);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      return {};
    }
    return {};
  }

  Future<void> setFiltersState(Map<String, dynamic> state) async {
    await _preferences.setString(PreferencesKeys.filtersState, jsonEncode(state));
  }

  Map<String, dynamic> getSortState() {
    final raw = _preferences.getString(PreferencesKeys.sortState);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      return {};
    }
    return {};
  }

  Future<void> setSortState(Map<String, dynamic> state) async {
    await _preferences.setString(PreferencesKeys.sortState, jsonEncode(state));
  }

  List<Collection> getCollections() {
    final raw = _preferences.getString(PreferencesKeys.collections);
    if (raw == null || raw.isEmpty) return const <Collection>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((entry) => Collection.fromJson(entry.cast<String, dynamic>()))
            .toList();
      }
    } catch (_) {
      return const <Collection>[];
    }
    return const <Collection>[];
  }

  Future<void> setCollections(List<Collection> collections) async {
    final encoded = jsonEncode(collections.map((collection) => collection.toJson()).toList());
    await _preferences.setString(PreferencesKeys.collections, encoded);
  }

  List<String> getCompareSelection() {
    return _preferences.getStringList(PreferencesKeys.compareSelection) ?? <String>[];
  }

  Future<void> setCompareSelection(List<String> ids) async {
    await _preferences.setStringList(PreferencesKeys.compareSelection, ids);
  }
}
