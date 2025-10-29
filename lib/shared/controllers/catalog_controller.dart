import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/auction.dart';
import '../models/bid.dart';
import '../models/listing.dart';
import '../models/wanted_request.dart';
import '../view_models/auction_view_model.dart';
import '../view_models/wanted_view_model.dart';
import '../controllers/search_controller.dart' as vm;
import '../controllers/pagination_controller.dart';
import '../controllers/refresh_controller.dart';
import '../utils/search_index.dart';
import '../../core/storage/shared_prefs_storage.dart';

class CatalogController extends ChangeNotifier {
  CatalogController({required SharedPrefsStorage storage})
      : _storage = storage,
        searchController = vm.SearchController(),
        refreshController = RefreshController(debounceMs: 600),
        paginationController = PaginationController(pageSize: 20);
  final List<AuctionViewModel> _auctions = [];
  final List<WantedViewModel> _wanted = [];
  final SharedPrefsStorage _storage;
  SearchIndex _searchIndex = SearchIndex();
  final List<SavedSearch> _savedSearches = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<AuctionViewModel> get auctions => List.unmodifiable(_auctions);
  List<WantedViewModel> get wanted => List.unmodifiable(_wanted);
  List<SavedSearch> get savedSearches => List.unmodifiable(_savedSearches);

  final vm.SearchController searchController;
  final RefreshController refreshController;
  final PaginationController paginationController;

  Future<void> bootstrap() async {
    await Future.wait([
      _loadAuctions(),
      _loadWanted(),
    ]);
    _searchIndex = SearchIndex()
      ..indexAuctions(_auctions)
      ..indexWanted(_wanted);
    _loadSavedSearches();
    notifyListeners();
  }

  Future<void> refresh() async {
    await refreshController.perform(() async {
      _auctions.clear();
      _wanted.clear();
      paginationController.reset();
      await bootstrap();
    });
  }

  List<SearchResult> search(String query, {SearchScope scope = SearchScope.all}) {
    return _searchIndex.search(query, scope: scope);
  }

  Future<void> saveSearch(String query, SearchScope scope) async {
    if (query.trim().isEmpty) return;
    final entry = SavedSearch(query: query.trim(), scope: scope);
    if (_savedSearches.any((element) => element == entry)) {
      return;
    }
    _savedSearches.insert(0, entry);
    await _persistSavedSearches();
    notifyListeners();
  }

  Future<void> removeSavedSearch(SavedSearch search) async {
    _savedSearches.removeWhere((element) => element == search);
    await _persistSavedSearches();
    notifyListeners();
  }

  void _loadSavedSearches() {
    final list = _storage.getStringList('user.savedSearches') ?? const [];
    _savedSearches
      ..clear()
      ..addAll(list.map(SavedSearch.decode));
  }

  Future<void> _persistSavedSearches() async {
    final list = _savedSearches.map((e) => e.encode()).toList(growable: false);
    await _storage.setStringList('user.savedSearches', list);
  }

  Future<void> _loadAuctions() async {
    _isLoading = true;
    notifyListeners();
    final raw = await rootBundle.loadString('assets/seed/auctions.json');
    final data = jsonDecode(raw) as List<dynamic>;
    for (final entry in data) {
      final map = entry as Map<String, dynamic>;
      final listing = Listing.fromJson(map['listing'] as Map<String, dynamic>);
      final auction = Auction.fromJson(map['auction'] as Map<String, dynamic>);
      final bids = (map['bids'] as List<dynamic>).map((e) => Bid.fromJson(e as Map<String, dynamic>)).toList();
      final seller = map['seller'] as Map<String, dynamic>;
      _auctions.add(
        AuctionViewModel(
          listing: listing,
          auction: auction,
          bids: bids,
          sellerName: seller['name'] as String,
          sellerAvatar: seller['avatarUrl'] as String,
          sellerReputation: (seller['reputation'] as num).toDouble(),
        ),
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadWanted() async {
    final raw = await rootBundle.loadString('assets/seed/wanted.json');
    final data = jsonDecode(raw) as List<dynamic>;
    for (final entry in data) {
      final item = WantedRequest.fromJson(entry as Map<String, dynamic>);
      _wanted.add(WantedViewModel(request: item));
    }
  }
}

class SavedSearch {
  const SavedSearch({required this.query, required this.scope});

  final String query;
  final SearchScope scope;

  String encode() => '${scope.name}|$query';

  static SavedSearch decode(String input) {
    final parts = input.split('|');
    final scopeName = parts.isNotEmpty ? parts.first : SearchScope.all.name;
    final scope = SearchScope.values.firstWhere(
      (element) => element.name == scopeName,
      orElse: () => SearchScope.all,
    );
    final query = parts.length > 1 ? parts.sublist(1).join('|') : '';
    return SavedSearch(query: query, scope: scope);
  }

  @override
  bool operator ==(Object other) {
    return other is SavedSearch && other.query == query && other.scope == scope;
  }

  @override
  int get hashCode => Object.hash(query, scope);
}
