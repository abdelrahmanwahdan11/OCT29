class Offer {
  const Offer({
    required this.id,
    this.forWantedId,
    this.forListingId,
    required this.sellerId,
    required this.price,
    required this.expiresUtc,
    this.note,
  });

  final String id;
  final String? forWantedId;
  final String? forListingId;
  final String sellerId;
  final double price;
  final DateTime expiresUtc;
  final String? note;

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as String,
      forWantedId: json['forWantedId'] as String?,
      forListingId: json['forListingId'] as String?,
      sellerId: json['sellerId'] as String,
      price: (json['price'] as num).toDouble(),
      expiresUtc: DateTime.parse(json['expiresUtc'] as String),
      note: json['note'] as String?,
    );
  }
}
