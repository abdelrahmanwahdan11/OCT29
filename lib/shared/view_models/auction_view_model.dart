import '../models/auction.dart';
import '../models/bid.dart';
import '../models/listing.dart';

class AuctionViewModel {
  const AuctionViewModel({
    required this.listing,
    required this.auction,
    required this.bids,
    required this.sellerName,
    required this.sellerAvatar,
    required this.sellerReputation,
  });

  final Listing listing;
  final Auction auction;
  final List<Bid> bids;
  final String sellerName;
  final String sellerAvatar;
  final double sellerReputation;

  double get currentBid => bids.isEmpty ? auction.startPrice : bids.last.amount;
  int get biddersCount => bids.map((b) => b.userId).toSet().length;
}
