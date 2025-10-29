class Auction {
  const Auction({
    required this.listingId,
    required this.startPrice,
    this.reservePrice,
    this.buyNowPrice,
    required this.incrementRule,
    required this.endTimeUtc,
    required this.antiSniping,
    required this.proxyEnabled,
  });

  final String listingId;
  final double startPrice;
  final double? reservePrice;
  final double? buyNowPrice;
  final double incrementRule;
  final DateTime endTimeUtc;
  final bool antiSniping;
  final bool proxyEnabled;

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      listingId: json['listingId'] as String,
      startPrice: (json['startPrice'] as num).toDouble(),
      reservePrice: (json['reservePrice'] as num?)?.toDouble(),
      buyNowPrice: (json['buyNowPrice'] as num?)?.toDouble(),
      incrementRule: (json['incrementRule'] as num).toDouble(),
      endTimeUtc: DateTime.parse(json['endTimeUtc'] as String),
      antiSniping: json['antiSniping'] as bool,
      proxyEnabled: json['proxyEnabled'] as bool,
    );
  }
}
