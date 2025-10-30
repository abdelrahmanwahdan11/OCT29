class Item {
  Item({
    required this.id,
    required this.title,
    required this.price,
    required List<String> imageUrls,
    required this.rating,
    required this.tags,
    required this.category,
    required this.description,
    this.brand = 'Catalog',
    Map<String, String>? specs,
    int? createdAt,
    this.isFavorite = false,
  })  : imageUrls = imageUrls.isNotEmpty ? List.unmodifiable(imageUrls) : const [],
        specs = specs != null ? Map.unmodifiable(specs) : const {},
        createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  final String id;
  final String title;
  final double price;
  final List<String> imageUrls;
  final double rating;
  final List<String> tags;
  final String category;
  final String description;
  final String brand;
  final Map<String, String> specs;
  final int createdAt;
  final bool isFavorite;

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  Item copyWith({
    bool? isFavorite,
    Map<String, String>? specs,
    int? createdAt,
  }) {
    return Item(
      id: id,
      title: title,
      price: price,
      imageUrls: imageUrls,
      rating: rating,
      tags: tags,
      category: category,
      description: description,
      brand: brand,
      specs: specs ?? this.specs,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
