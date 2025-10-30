import 'dart:math';

import '../models/category.dart';
import '../models/item.dart';

class MockDataFactory {
  static const _categories = [
    'Electronics',
    'Home',
    'Fashion',
    'Sports',
    'Books',
    'Beauty',
  ];

  static const _filters = ['Featured', 'Top Rated', 'New', 'On Sale'];

  static List<Category> buildCategories() {
    return _categories
        .map((name) => Category(id: name.toLowerCase(), name: name, icon: 'category'))
        .toList();
  }

  static List<Item> buildItems({int total = 200}) {
    final random = Random(42);
    return List.generate(total, (index) {
      final id = 'item-$index';
      final category = _categories[index % _categories.length];
      final price = 10 + random.nextDouble() * (999 - 10);
      final ratingOptions = [3.5, 4.0, 4.5, 5.0];
      final rating = ratingOptions[index % ratingOptions.length];
      final filterTag = _filters[index % _filters.length];
      final imageBase = 'https://picsum.photos/seed/$id/600/600';
      final createdAt = DateTime.now().subtract(Duration(days: index)).millisecondsSinceEpoch;
      return Item(
        id: id,
        title: 'Sample Item ${index + 1}',
        price: double.parse(price.toStringAsFixed(2)),
        imageUrls: List.generate(3, (i) => '$imageBase?variant=$i'),
        rating: rating,
        tags: [category, filterTag],
        category: category,
        description:
            'This is a beautifully crafted description for Sample Item ${index + 1}. It highlights features, materials, and use cases with clarity.',
        brand: 'Brand ${index % 8 + 1}',
        specs: {
          'Material': 'Premium blend',
          'Weight': '${1.2 + random.nextDouble()}kg',
          'Warranty': '${1 + index % 3} year',
        },
        createdAt: createdAt,
      );
    });
  }
}
