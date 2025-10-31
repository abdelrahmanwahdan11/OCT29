import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/car.dart';
import '../../domain/enums/condition.dart';
import '../../domain/enums/fuel_type.dart';
import '../../domain/enums/transmission.dart';

class CarLocalDataSource {
  CarLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _catalogKey = 'data.cars';
  static const _favoritesKey = 'data.favorites';
  static const _compareKey = 'data.compare';

  Future<List<Car>> loadSeedCars() async {
    final data = await rootBundle.loadString('assets/data/cars.json');
    final List<dynamic> jsonList = json.decode(data) as List<dynamic>;
    return jsonList.map((dynamic item) => _mapCar(item as Map<String, dynamic>)).toList();
  }

  Future<void> cacheCars(List<Car> cars) async {
    final jsonList = cars.map(_mapCarToJson).toList();
    await _prefs.setString(_catalogKey, json.encode(jsonList));
  }

  Future<List<Car>> loadCachedCars() async {
    final value = _prefs.getString(_catalogKey);
    if (value == null) {
      return const <Car>[];
    }
    final List<dynamic> jsonList = json.decode(value) as List<dynamic>;
    return jsonList.map((dynamic item) => _mapCar(item as Map<String, dynamic>)).toList();
  }

  Future<List<String>> loadFavoriteIds() async {
    final value = _prefs.getStringList(_favoritesKey);
    return value ?? <String>[];
  }

  Future<void> saveFavoriteIds(List<String> ids) async {
    await _prefs.setStringList(_favoritesKey, ids);
  }

  Future<List<String>> loadCompareIds() async {
    final value = _prefs.getStringList(_compareKey);
    return value ?? <String>[];
  }

  Future<void> saveCompareIds(List<String> ids) async {
    await _prefs.setStringList(_compareKey, ids);
  }

  Map<String, dynamic> _mapCarToJson(Car car) {
    return <String, dynamic>{
      'id': car.id,
      'brand': car.brand,
      'model': car.model,
      'year': car.year,
      'images': car.images,
      'spinset_360': car.spinset360,
      'price': car.price,
      'currency': car.currency,
      'mileage_km': car.mileageKm,
      'horsepower': car.horsepower,
      'seats': car.seats,
      'top_speed_kmh': car.topSpeedKmh,
      'acceleration_0_100': car.acceleration0100,
      'fuel': car.fuel.storageValue,
      'transmission': car.transmission.storageValue,
      'drivetrain': car.drivetrain,
      'battery_range_km': car.batteryRangeKm,
      'location_city': car.locationCity,
      'is_featured': car.isFeatured,
      'condition': car.condition.storageValue,
      'description': car.description,
      'is_favorite': car.isFavorite,
    };
  }

  Car _mapCar(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      images: (json['images'] as List<dynamic>).cast<String>(),
      spinset360: (json['spinset_360'] as List<dynamic>?)?.cast<String>(),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      mileageKm: json['mileage_km'] as int,
      horsepower: json['horsepower'] as int,
      seats: json['seats'] as int,
      topSpeedKmh: json['top_speed_kmh'] as int,
      acceleration0100: (json['acceleration_0_100'] as num).toDouble(),
      fuel: FuelTypeX.fromString(json['fuel'] as String),
      transmission: TransmissionX.fromString(json['transmission'] as String),
      drivetrain: json['drivetrain'] as String,
      batteryRangeKm: json['battery_range_km'] as int?,
      locationCity: json['location_city'] as String,
      isFeatured: json['is_featured'] as bool,
      condition: ConditionX.fromString(json['condition'] as String),
      description: json['description'] as String,
      isFavorite: json['is_favorite'] as bool,
    );
  }
}
