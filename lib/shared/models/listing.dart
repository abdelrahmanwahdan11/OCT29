class Listing {
  const Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.brand,
    required this.condition,
    required this.images,
    this.videoUrl,
    required this.location,
    required this.deliveryOptions,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String brand;
  final String condition;
  final List<String> images;
  final String? videoUrl;
  final String location;
  final List<String> deliveryOptions;

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      brand: json['brand'] as String,
      condition: json['condition'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      videoUrl: json['videoUrl'] as String?,
      location: json['location'] as String,
      deliveryOptions: (json['deliveryOptions'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'brand': brand,
        'condition': condition,
        'images': images,
        'videoUrl': videoUrl,
        'location': location,
        'deliveryOptions': deliveryOptions,
      };
}
