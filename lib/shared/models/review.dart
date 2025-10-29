class Review {
  const Review({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.rating,
    required this.comment,
    required this.tsUtc,
  });

  final String id;
  final String fromUserId;
  final String toUserId;
  final double rating;
  final String comment;
  final DateTime tsUtc;
}
