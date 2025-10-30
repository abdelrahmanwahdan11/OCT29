import 'dart:async';

import '../mock/mock_data.dart';
import '../models/item.dart';

class CatalogRepository {
  CatalogRepository() {
    _allItems = MockDataFactory.buildItems();
  }

  late final List<Item> _allItems;

  Future<List<Item>> fetchItems({
    required int page,
    required int pageSize,
    String? category,
    String? filter,
    String? query,
    String? sort,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    Iterable<Item> data = _allItems;

    if (category != null && category.isNotEmpty && category != 'all') {
      data = data.where((item) => item.category.toLowerCase() == category.toLowerCase());
    }

    if (filter != null && filter.isNotEmpty && filter != 'All') {
      data = data.where((item) => item.tags.contains(filter));
    }

    if (query != null && query.isNotEmpty) {
      final lower = query.toLowerCase();
      data = data.where(
        (item) =>
            item.title.toLowerCase().contains(lower) ||
            item.tags.any((tag) => tag.toLowerCase().contains(lower)) ||
            item.category.toLowerCase().contains(lower),
      );
    }

    if (sort != null && sort.isNotEmpty) {
      final list = data.toList();
      switch (sort) {
        case 'price_low_high':
          list.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_high_low':
          list.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'rating_high_low':
          list.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'newest_first':
        default:
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }
      data = list;
    }

    final start = page * pageSize;
    final end = start + pageSize;
    final items = data.toList();
    if (start >= items.length) {
      return [];
    }
    return items.sublist(start, end.clamp(0, items.length));
  }

  Item? findById(String id) {
    try {
      return _allItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Item> relatedItems({required String category, required String excludeId, int limit = 6}) {
    return _allItems
        .where((item) => item.category.toLowerCase() == category.toLowerCase() && item.id != excludeId)
        .take(limit)
        .toList();
  }
}
