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
    this.model3dUrl,
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
  final String? model3dUrl;

  String get title => '$brand $model';

  Car copyWith({
    bool? isFavorite,
  }) {
    return Car(
      id: id,
      brand: brand,
      model: model,
      year: year,
      images: List<String>.from(images),
      spinset360: spinset360 == null ? null : List<String>.from(spinset360!),
      price: price,
      currency: currency,
      mileageKm: mileageKm,
      horsepower: horsepower,
      seats: seats,
      topSpeedKmh: topSpeedKmh,
      acceleration0100: acceleration0100,
      fuel: fuel,
      transmission: transmission,
      drivetrain: drivetrain,
      batteryRangeKm: batteryRangeKm,
      locationCity: locationCity,
      isFeatured: isFeatured,
      condition: condition,
      description: description,
      isFavorite: isFavorite ?? this.isFavorite,
      model3dUrl: model3dUrl,
    );
  }
}
