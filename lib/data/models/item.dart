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
    this.isFavorite = false,
  }) : imageUrls = imageUrls.isNotEmpty ? List.unmodifiable(imageUrls) : const [];

  final String id;
  final String title;
  final double price;
  final List<String> imageUrls;
  final double rating;
  final List<String> tags;
  final String category;
  final String description;
  final bool isFavorite;

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  Item copyWith({
    bool? isFavorite,
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
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
