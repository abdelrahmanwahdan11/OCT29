class OfferWatch {
  const OfferWatch({
    required this.carId,
    required this.targetPrice,
    required this.notifyOnMatch,
  });

  final String carId;
  final double targetPrice;
  final bool notifyOnMatch;
}
