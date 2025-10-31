import 'dart:convert';

class OfferWatch {
  const OfferWatch({
    required this.carId,
    required this.targetPrice,
    required this.notifyOnMatch,
  });

  final String carId;
  final double targetPrice;
  final bool notifyOnMatch;

  OfferWatch copyWith({
    String? carId,
    double? targetPrice,
    bool? notifyOnMatch,
  }) {
    return OfferWatch(
      carId: carId ?? this.carId,
      targetPrice: targetPrice ?? this.targetPrice,
      notifyOnMatch: notifyOnMatch ?? this.notifyOnMatch,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'carId': carId,
      'targetPrice': targetPrice,
      'notifyOnMatch': notifyOnMatch,
    };
  }

  static OfferWatch fromJson(Map<String, dynamic> json) {
    return OfferWatch(
      carId: json['carId'] as String,
      targetPrice: (json['targetPrice'] as num).toDouble(),
      notifyOnMatch: json['notifyOnMatch'] as bool,
    );
  }

  static List<OfferWatch> decodeList(String? value) {
    if (value == null || value.isEmpty) {
      return const <OfferWatch>[];
    }
    final List<dynamic> list = json.decode(value) as List<dynamic>;
    return list
        .map((dynamic item) => OfferWatch.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static String encodeList(List<OfferWatch> watches) {
    return json.encode(watches.map((watch) => watch.toJson()).toList());
  }
}
