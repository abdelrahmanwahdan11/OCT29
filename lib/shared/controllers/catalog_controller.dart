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

class CatalogController extends ChangeNotifier {
  CatalogController()
      : searchController = vm.SearchController(),
        refreshController = RefreshController(debounceMs: 600),
        paginationController = PaginationController(pageSize: 20);
  final List<AuctionViewModel> _auctions = [];
  final List<WantedViewModel> _wanted = [];
  SearchIndex _searchIndex = SearchIndex();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<AuctionViewModel> get auctions => List.unmodifiable(_auctions);
  List<WantedViewModel> get wanted => List.unmodifiable(_wanted);

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
