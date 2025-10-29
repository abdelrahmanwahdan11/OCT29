class WantedRequest {
  const WantedRequest({
    required this.id,
    required this.title,
    required this.specs,
    required this.budgetMin,
    required this.budgetMax,
    required this.location,
    required this.radiusKm,
    required this.timeframe,
    this.images,
  });

  final String id;
  final String title;
  final String specs;
  final double budgetMin;
  final double budgetMax;
  final String location;
  final double radiusKm;
  final String timeframe;
  final List<String>? images;

  factory WantedRequest.fromJson(Map<String, dynamic> json) {
    return WantedRequest(
      id: json['id'] as String,
      title: json['title'] as String,
      specs: json['specs'] as String,
      budgetMin: (json['budgetMin'] as num).toDouble(),
      budgetMax: (json['budgetMax'] as num).toDouble(),
      location: json['location'] as String,
      radiusKm: (json['radiusKm'] as num).toDouble(),
      timeframe: json['timeframe'] as String,
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
    );
  }
}
