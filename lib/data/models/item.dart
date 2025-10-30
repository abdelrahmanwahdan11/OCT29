class Item {
  Item({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.tags,
    required this.category,
    required this.description,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final double rating;
  final List<String> tags;
  final String category;
  final String description;
  final bool isFavorite;

  Item copyWith({
    bool? isFavorite,
  }) {
    return Item(
      id: id,
      title: title,
      price: price,
      imageUrl: imageUrl,
      rating: rating,
      tags: tags,
      category: category,
      description: description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
