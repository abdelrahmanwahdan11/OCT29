import 'dart:async';

import 'package:flutter/material.dart';

import '../core/utils/routes.dart';
import '../data/mock/mock_data.dart';
import '../data/models/category.dart';
import '../data/models/collection.dart';
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
  List<String> _savedSearches = [];
  String _sortOrder = 'newest_first';
  Map<String, Collection> _collections = {};
  List<String> _compareSelection = [];

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
  List<String> get savedSearches => List.unmodifiable(_savedSearches);
  String get sortOrder => _sortOrder;
  List<Collection> get collections {
    final list = _collections.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  List<String> get compareSelection => List.unmodifiable(_compareSelection);

  List<String> get trendingSearches => const ['Phone', 'Shoes', 'Watch', 'Headphones'];

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
    _savedSearches = preferences.getSavedSearches();
    final storedCollections = preferences.getCollections();
    _collections = {for (final collection in storedCollections) collection.id: collection};
    final storedCompare = preferences.getCompareSelection();
    final seen = <String>{};
    _compareSelection = [];
    for (final id in storedCompare) {
      if (seen.length >= 3) break;
      if (seen.add(id)) {
        _compareSelection.add(id);
      }
    }
    final filtersState = preferences.getFiltersState();
    final sortState = preferences.getSortState();
    _selectedCategory = (filtersState['category'] as String?) ?? 'all';
    _selectedFilter = (filtersState['filter'] as String?) ?? 'All';
    _sortOrder = (sortState['order'] as String?) ?? 'newest_first';
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
      sort: _sortOrder,
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
      sort: _sortOrder,
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
    await _persistFilters();
    await loadInitialItems();
  }

  Future<void> selectFilter(String filter) async {
    _selectedFilter = filter;
    await _persistFilters();
    await loadInitialItems();
  }

  Future<void> setSortOrder(String sort) async {
    if (_sortOrder == sort) return;
    _sortOrder = sort;
    await preferences.setSortState({'order': sort});
    await loadInitialItems();
  }

  Future<void> clearFilters() async {
    _selectedCategory = 'all';
    _selectedFilter = 'All';
    await _persistFilters();
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

  Future<void> restoreFavorites(Iterable<String> ids) async {
    favorites.addAll(ids);
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

  Collection? findCollection(String id) => _collections[id];

  Future<Collection> createCollection(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Collection name cannot be empty');
    }
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final collection = Collection(id: id, name: trimmed, itemIds: const []);
    _collections[id] = collection;
    await _persistCollections();
    notifyListeners();
    return collection;
  }

  Future<void> renameCollection(String id, String name) async {
    final trimmed = name.trim();
    final existing = _collections[id];
    if (existing == null || trimmed.isEmpty) return;
    _collections[id] = existing.copyWith(name: trimmed);
    await _persistCollections();
    notifyListeners();
  }

  Future<void> deleteCollection(String id) async {
    if (_collections.remove(id) != null) {
      await _persistCollections();
      notifyListeners();
    }
  }

  Future<void> addItemToCollection(String collectionId, String itemId) async {
    final existing = _collections[collectionId];
    if (existing == null || existing.itemIds.contains(itemId)) return;
    final updated = existing.copyWith(itemIds: [...existing.itemIds, itemId]);
    _collections[collectionId] = updated;
    await _persistCollections();
    notifyListeners();
  }

  Future<void> removeItemFromCollection(String collectionId, String itemId) async {
    final existing = _collections[collectionId];
    if (existing == null || !existing.itemIds.contains(itemId)) return;
    final updated = existing.copyWith(
      itemIds: existing.itemIds.where((id) => id != itemId).toList(),
    );
    _collections[collectionId] = updated;
    await _persistCollections();
    notifyListeners();
  }

  bool isItemInCollection(String collectionId, String itemId) {
    return _collections[collectionId]?.contains(itemId) ?? false;
  }

  List<Item> getCollectionItems(String collectionId) {
    final collection = _collections[collectionId];
    if (collection == null) return const [];
    return collection.itemIds
        .map(findItemById)
        .whereType<Item>()
        .map(_applyFavorite)
        .toList();
  }

  bool isInCompare(String itemId) => _compareSelection.contains(itemId);

  Future<bool> addToCompare(String itemId) async {
    if (_compareSelection.contains(itemId)) {
      return true;
    }
    if (_compareSelection.length >= 3) {
      return false;
    }
    _compareSelection.add(itemId);
    await _persistCompare();
    notifyListeners();
    return true;
  }

  Future<void> removeFromCompare(String itemId) async {
    if (_compareSelection.remove(itemId)) {
      await _persistCompare();
      notifyListeners();
    }
  }

  Future<void> clearCompare() async {
    if (_compareSelection.isEmpty) return;
    _compareSelection.clear();
    await _persistCompare();
    notifyListeners();
  }

  List<Item> getCompareItems() {
    return _compareSelection
        .map(findItemById)
        .whereType<Item>()
        .map(_applyFavorite)
        .toList();
  }

  String buildCompareSummary() {
    final buffer = StringBuffer();
    for (final item in getCompareItems()) {
      buffer
        ..writeln(item.title)
        ..writeln('Price: USD ${item.price.toStringAsFixed(2)}')
        ..writeln('Brand: ${item.brand}')
        ..writeln('Rating: ${item.rating}')
        ..writeln('Category: ${item.category}');
      if (item.specs.isNotEmpty) {
        buffer.writeln('Specs:');
        item.specs.forEach((key, value) {
          buffer.writeln('- $key: $value');
        });
      }
      buffer.writeln();
    }
    return buffer.toString().trim();
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

  Future<void> saveSearchQuery(String query) async {
    final sanitized = query.trim();
    if (sanitized.isEmpty) return;
    _savedSearches.removeWhere((term) => term.toLowerCase() == sanitized.toLowerCase());
    _savedSearches.insert(0, sanitized);
    if (_savedSearches.length > 10) {
      _savedSearches = _savedSearches.sublist(0, 10);
    }
    await preferences.setSavedSearches(_savedSearches);
    notifyListeners();
  }

  Future<void> removeSavedSearch(String query) async {
    _savedSearches.removeWhere((term) => term.toLowerCase() == query.toLowerCase());
    await preferences.setSavedSearches(_savedSearches);
    notifyListeners();
  }

  Future<void> clearSavedSearches() async {
    _savedSearches = [];
    await preferences.setSavedSearches(_savedSearches);
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

  Future<void> _persistFilters() {
    return preferences.setFiltersState({
      'category': _selectedCategory,
      'filter': _selectedFilter,
    });
  }

  Future<void> _persistCollections() {
    return preferences.setCollections(_collections.values.toList());
  }

  Future<void> _persistCompare() {
    return preferences.setCompareSelection(_compareSelection);
  }
}

class CategoryChip {
  const CategoryChip({required this.id, required this.label});

  final String id;
  final String label;
}
