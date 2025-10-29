class Bid {
  const Bid({
    required this.auctionId,
    required this.userId,
    required this.amount,
    required this.tsUtc,
    this.proxyMax,
  });

  final String auctionId;
  final String userId;
  final double amount;
  final DateTime tsUtc;
  final double? proxyMax;

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      auctionId: json['auctionId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      tsUtc: DateTime.parse(json['tsUtc'] as String),
      proxyMax: (json['proxyMax'] as num?)?.toDouble(),
    );
  }
}
