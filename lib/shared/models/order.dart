class Order {
  const Order({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.amount,
    required this.status,
    required this.escrowHeld,
    this.tracking,
  });

  final String id;
  final String buyerId;
  final String sellerId;
  final double amount;
  final String status;
  final bool escrowHeld;
  final String? tracking;
}
