class Listing {
  const Listing({
    required this.carId,
    required this.sellerId,
    required this.listPrice,
    required this.isAcceptingOffers,
    required this.instantBuyEnabled,
    required this.createdAt,
  });

  final String carId;
  final String sellerId;
  final double listPrice;
  final bool isAcceptingOffers;
  final bool instantBuyEnabled;
  final DateTime createdAt;
}
