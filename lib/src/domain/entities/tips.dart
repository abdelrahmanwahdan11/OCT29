class Tip {
  const Tip({
    required this.carId,
    required this.oilChangeKmInterval,
    required this.tirePressureFront,
    required this.tirePressureRear,
    required this.customNotes,
  });

  final String carId;
  final int oilChangeKmInterval;
  final int tirePressureFront;
  final int tirePressureRear;
  final String customNotes;

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      carId: json['car_id'] as String,
      oilChangeKmInterval: json['oil_change_km_interval'] as int? ?? 0,
      tirePressureFront: json['tire_pressure_front'] as int? ?? 0,
      tirePressureRear: json['tire_pressure_rear'] as int? ?? 0,
      customNotes: json['custom_notes'] as String? ?? '',
    );
  }
}
