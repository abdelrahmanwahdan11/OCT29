import '../enums/condition.dart';
import '../enums/fuel_type.dart';
import '../enums/transmission.dart';

class Car {
  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.images,
    required this.price,
    required this.currency,
    required this.mileageKm,
    required this.horsepower,
    required this.seats,
    required this.topSpeedKmh,
    required this.acceleration0100,
    required this.fuel,
    required this.transmission,
    required this.drivetrain,
    required this.locationCity,
    required this.isFeatured,
    required this.condition,
    required this.description,
    required this.isFavorite,
    this.spinset360,
    this.batteryRangeKm,
  });

  final String id;
  final String brand;
  final String model;
  final int year;
  final List<String> images;
  final List<String>? spinset360;
  final double price;
  final String currency;
  final int mileageKm;
  final int horsepower;
  final int seats;
  final int topSpeedKmh;
  final double acceleration0100;
  final FuelType fuel;
  final Transmission transmission;
  final String drivetrain;
  final int? batteryRangeKm;
  final String locationCity;
  final bool isFeatured;
  final Condition condition;
  final String description;
  final bool isFavorite;

  String get title => '$brand $model';

  Car copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    List<String>? images,
    List<String>? spinset360,
    double? price,
    String? currency,
    int? mileageKm,
    int? horsepower,
    int? seats,
    int? topSpeedKmh,
    double? acceleration0100,
    FuelType? fuel,
    Transmission? transmission,
    String? drivetrain,
    int? batteryRangeKm,
    String? locationCity,
    bool? isFeatured,
    Condition? condition,
    String? description,
    bool? isFavorite,
  }) {
    return Car(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      images: images != null ? List<String>.from(images) : List<String>.from(this.images),
      spinset360: spinset360 != null
          ? List<String>.from(spinset360)
          : (this.spinset360 == null ? null : List<String>.from(this.spinset360!)),
      price: price ?? this.price,
      currency: currency ?? this.currency,
      mileageKm: mileageKm ?? this.mileageKm,
      horsepower: horsepower ?? this.horsepower,
      seats: seats ?? this.seats,
      topSpeedKmh: topSpeedKmh ?? this.topSpeedKmh,
      acceleration0100: acceleration0100 ?? this.acceleration0100,
      fuel: fuel ?? this.fuel,
      transmission: transmission ?? this.transmission,
      drivetrain: drivetrain ?? this.drivetrain,
      batteryRangeKm: batteryRangeKm ?? this.batteryRangeKm,
      locationCity: locationCity ?? this.locationCity,
      isFeatured: isFeatured ?? this.isFeatured,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
