import 'dart:async';

import 'package:flutter/material.dart';

import '../core/utils/routes.dart';
import '../data/mock/mock_data.dart';
import '../data/models/category.dart';
import '../data/models/item.dart';
import '../data/models/user.dart';
import '../data/repositories/catalog_repository.dart';
import '../services/preferences_service.dart';

enum FeedLayout { grid, list }

class AppState extends ChangeNotifier {
  AppState(this.preferences)
      : repository = CatalogRepository(),
        categories = MockDataFactory.buildCategories();

  final PreferencesService preferences;
  final CatalogRepository repository;
  final List<Category> categories;
  final List<CategoryChip> filters = const [
    CategoryChip(id: 'All', label: 'All'),
    CategoryChip(id: 'Featured', label: 'Featured'),
    CategoryChip(id: 'Top Rated', label: 'Top Rated'),
    CategoryChip(id: 'New', label: 'New'),
    CategoryChip(id: 'On Sale', label: 'On Sale'),
  ];

  ThemeMode themeMode = ThemeMode.system;
  Locale locale = const Locale('ar');
  bool notificationsEnabled = true;
  bool hasSeenOnboarding = false;
  bool guestSession = false;
  User? user;
  Set<String> favorites = {};
  FeedLayout feedLayout = FeedLayout.grid;

  List<String> _searchHistory = [];
  List<String> _recentlyViewed = [];

  static const int _pageSize = 20;
  int _page = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String _selectedCategory = 'all';
  String _selectedFilter = 'All';
  String _searchQuery = '';
  List<Item> _items = [];

  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String get selectedCategory => _selectedCategory;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  Future<void> initialize() async {
    hasSeenOnboarding = preferences.getHasSeenOnboarding();
    favorites = preferences.getFavorites();
    guestSession = preferences.isGuestSession();
    final storedLocale = preferences.getStoredLocaleCode();
    locale = Locale(storedLocale ?? 'ar');
    final storedTheme = preferences.getThemeMode();
    themeMode = switch (storedTheme) {
      StoredThemeMode.system => ThemeMode.system,
      StoredThemeMode.light => ThemeMode.light,
      StoredThemeMode.dark => ThemeMode.dark,
    };
    final storedLayout = preferences.getFeedLayout();
    feedLayout = storedLayout == 'list' ? FeedLayout.list : FeedLayout.grid;
    _searchHistory = preferences.getSearchHistory();
    _recentlyViewed = preferences.getRecentlyViewed();
    if (guestSession) {
      user = User(id: 'guest', name: 'Guest');
    }
    await loadInitialItems();
  }

  Future<void> loadInitialItems() async {
    _page = 0;
    _hasMore = true;
    _isLoading = true;
    notifyListeners();
    final data = await repository.fetchItems(
      page: _page,
      pageSize: _pageSize,
      category: _selectedCategory,
      filter: _selectedFilter,
      query: _searchQuery,
    );
    _items = data.map(_applyFavorite).toList();
    _isLoading = false;
    _hasMore = data.length == _pageSize;
    notifyListeners();
  }

  Future<void> refreshItems() async {
    await loadInitialItems();
  }

  Future<void> loadMoreItems() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();
    _page += 1;
    final data = await repository.fetchItems(
      page: _page,
      pageSize: _pageSize,
      category: _selectedCategory,
      filter: _selectedFilter,
      query: _searchQuery,
    );
    if (data.isEmpty) {
      _hasMore = false;
    } else {
      _items = [..._items, ...data.map(_applyFavorite)];
    }
    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> setSearchQuery(String query) async {
    _searchQuery = query;
    await loadInitialItems();
    if (query.isNotEmpty) {
      await _addSearchHistory(query);
    }
  }

  Future<void> selectCategory(String category) async {
    _selectedCategory = category;
    await loadInitialItems();
  }

  Future<void> selectFilter(String filter) async {
    _selectedFilter = filter;
    await loadInitialItems();
  }

  Item _applyFavorite(Item item) {
    return item.copyWith(isFavorite: favorites.contains(item.id));
  }

  void toggleFavorite(Item item) {
    if (favorites.contains(item.id)) {
      favorites.remove(item.id);
    } else {
      favorites.add(item.id);
    }
    preferences.setFavorites(favorites);
    _items = _items.map(_applyFavorite).toList();
    notifyListeners();
  }

  Future<void> removeFavorites(Set<String> ids) async {
    if (ids.isEmpty) return;
    favorites.removeAll(ids);
    await preferences.setFavorites(favorites);
    _items = _items.map(_applyFavorite).toList();
    notifyListeners();
  }

  List<Item> getFavoriteItems() {
    final favoriteIds = favorites;
    final favoriteItems = <Item>[];
    for (final id in favoriteIds) {
      final existing = _items.where((item) => item.id == id);
      if (existing.isNotEmpty) {
        favoriteItems.add(existing.first);
        continue;
      }
      final repoItem = repository.findById(id);
      if (repoItem != null) {
        favoriteItems.add(repoItem.copyWith(isFavorite: true));
      }
    }
    return favoriteItems;
  }

  bool get isAuthenticated => user != null;

  Future<void> setFeedLayout(FeedLayout layout) async {
    if (feedLayout == layout) return;
    feedLayout = layout;
    await preferences.setFeedLayout(layout == FeedLayout.grid ? 'grid' : 'list');
    notifyListeners();
  }

  Future<void> clearSearchHistory() async {
    _searchHistory = [];
    await preferences.setSearchHistory(_searchHistory);
    notifyListeners();
  }

  Future<void> _addSearchHistory(String query) async {
    final sanitized = query.trim();
    if (sanitized.isEmpty) return;
    final normalized = sanitized.toLowerCase();
    _searchHistory.removeWhere((term) => term.toLowerCase() == normalized);
    _searchHistory.insert(0, sanitized);
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }
    await preferences.setSearchHistory(_searchHistory);
    notifyListeners();
  }

  void recordRecentlyViewed(String id) {
    if (id.isEmpty) return;
    _recentlyViewed.remove(id);
    _recentlyViewed.insert(0, id);
    if (_recentlyViewed.length > 10) {
      _recentlyViewed = _recentlyViewed.sublist(0, 10);
    }
    preferences.setRecentlyViewed(_recentlyViewed);
    notifyListeners();
  }

  List<Item> getRecentlyViewedItems() {
    return _recentlyViewed
        .map((id) => findItemById(id))
        .whereType<Item>()
        .map(_applyFavorite)
        .toList();
  }

  List<Item> getRelatedItems(String id, {int limit = 6}) {
    final base = findItemById(id);
    if (base == null) return [];
    return repository
        .relatedItems(category: base.category, excludeId: id, limit: limit)
        .map(_applyFavorite)
        .toList();
  }

  Future<void> completeOnboarding() async {
    hasSeenOnboarding = true;
    await preferences.setHasSeenOnboarding(true);
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    themeMode = mode;
    final stored = switch (mode) {
      ThemeMode.system => StoredThemeMode.system,
      ThemeMode.light => StoredThemeMode.light,
      ThemeMode.dark => StoredThemeMode.dark,
    };
    await preferences.setThemeMode(stored);
    notifyListeners();
  }

  Future<void> setLocale(Locale value) async {
    locale = value;
    await preferences.setLocaleCode(value.languageCode);
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    user = User(id: email, name: email.split('@').first, email: email);
    guestSession = false;
    await preferences.setGuestSession(false);
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    user = User(id: email, name: name, email: email);
    guestSession = false;
    await preferences.setGuestSession(false);
    notifyListeners();
  }

  Future<void> continueAsGuest() async {
    user = User(id: 'guest', name: 'Guest');
    guestSession = true;
    await preferences.setGuestSession(true);
    notifyListeners();
  }

  Future<void> logout() async {
    user = null;
    guestSession = false;
    await preferences.setGuestSession(false);
    notifyListeners();
  }

  String get initialRoute {
    if (!hasSeenOnboarding) return AppRoutes.onboarding;
    if (!isAuthenticated) return AppRoutes.login;
    return AppRoutes.home;
  }

  Item? findItemById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return repository.findById(id)?.copyWith(isFavorite: favorites.contains(id));
    }
  }
}

class CategoryChip {
  const CategoryChip({required this.id, required this.label});

  final String id;
  final String label;
}
