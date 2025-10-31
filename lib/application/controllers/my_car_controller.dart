import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/car.dart';
import '../../domain/entities/offer_watch.dart';
import '../../domain/enums/condition.dart';
import '../../domain/enums/fuel_type.dart';
import '../../domain/enums/transmission.dart';
import '../../domain/repositories/car_repository.dart';

class MyCarController extends ChangeNotifier {
  MyCarController(this._prefs, this._repository) {
    _loadOfferWatches();
  }

  static const String _offerWatchKey = 'data.offer_watches';

  final SharedPreferences _prefs;
  final CarRepository _repository;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String brand = '';
  String model = '';
  int year = DateTime.now().year;
  Condition condition = Condition.newCar;
  double price = 0;
  int mileage = 0;
  FuelType fuel = FuelType.petrol;
  Transmission transmission = Transmission.automatic;
  int seats = 5;
  int horsepower = 0;
  String description = '';
  String city = '';
  bool acceptingOffers = true;
  int lastOilChangeKm = 0;
  int currentMileage = 0;

  List<String> images = <String>[];
  List<String> spinset360 = <String>[];
  String model3dUrl = '';

  final List<OfferWatch> _offerWatches = <OfferWatch>[];
  List<OfferWatch> get offerWatches => List.unmodifiable(_offerWatches);

  bool get needsOilChange => currentMileage > 0 && currentMileage - lastOilChangeKm >= 8000;

  String get imagesMultiline => images.join('\n');
  String get spinsetMultiline => spinset360.join('\n');

  void updateImages(String value) {
    images = _parseMultiline(value);
    notifyListeners();
  }

  void updateSpinset(String value) {
    spinset360 = _parseMultiline(value);
    notifyListeners();
  }

  void updateModel3dUrl(String value) {
    model3dUrl = value.trim();
    notifyListeners();
  }

  void updateLastOilChange(String value) {
    lastOilChangeKm = int.tryParse(value) ?? lastOilChangeKm;
    notifyListeners();
  }

  void updateCurrentMileage(String value) {
    currentMileage = int.tryParse(value) ?? currentMileage;
    notifyListeners();
  }

  Future<void> addOfferWatch(OfferWatch watch) async {
    _offerWatches.insert(0, watch);
    await _persistOfferWatches();
    notifyListeners();
  }

  Future<void> removeOfferWatch(int index) async {
    if (index < 0 || index >= _offerWatches.length) return;
    _offerWatches.removeAt(index);
    await _persistOfferWatches();
    notifyListeners();
  }

  Future<void> toggleOfferWatchNotify(int index, bool value) async {
    if (index < 0 || index >= _offerWatches.length) return;
    final watch = _offerWatches[index];
    _offerWatches[index] = watch.copyWith(notifyOnMatch: value);
    await _persistOfferWatches();
    notifyListeners();
  }

  Future<void> refreshOfferWatches() async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    notifyListeners();
  }

  void saveForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
    }
  }

  Future<void> saveOnly() async {
    saveForm();
  }

  Car buildCarFromForm() {
    saveForm();
    final List<String> carImages = images.isEmpty
        ? <String>['https://images.unsplash.com/photo-1494972688394-4cc796f9e4c1']
        : List<String>.from(images);
    final List<String>? frames = spinset360.isEmpty ? null : List<String>.from(spinset360);
    return Car(
      id: 'mycar_${DateTime.now().millisecondsSinceEpoch}',
      brand: brand,
      model: model,
      year: year,
      images: carImages,
      spinset360: frames,
      price: price,
      currency: 'USD',
      mileageKm: mileage,
      horsepower: horsepower,
      seats: seats,
      topSpeedKmh: _deriveTopSpeed(),
      acceleration0100: _deriveAcceleration(),
      fuel: fuel,
      transmission: transmission,
      drivetrain: 'FWD',
      batteryRangeKm: fuel == FuelType.electric ? 380 : null,
      locationCity: city.isEmpty ? '—' : city,
      isFeatured: false,
      condition: condition,
      description: description.isEmpty
          ? '${brand.isEmpty ? 'Your car' : brand} ${model.isEmpty ? '' : model} listing.'
          : description,
      isFavorite: false,
      model3dUrl: model3dUrl.isEmpty ? null : model3dUrl,
    );
  }

  Future<void> insertIntoCatalog(Car car) async {
    final cars = await _repository.loadCachedCars();
    cars.removeWhere((existing) => existing.id == car.id);
    cars.insert(0, car);
    await _repository.cacheCars(cars);
  }

  List<String> _parseMultiline(String value) {
    return value
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  int _deriveTopSpeed() {
    if (horsepower <= 0) {
      return 200;
    }
    return (horsepower * 1.2).clamp(160, 360).toInt();
  }

  double _deriveAcceleration() {
    if (horsepower <= 0) {
      return 7.2;
    }
    final double estimate = 12 - (horsepower / 100);
    return estimate.clamp(3.5, 12.0);
  }

  Future<void> _persistOfferWatches() async {
    await _prefs.setString(_offerWatchKey, OfferWatch.encodeList(_offerWatches));
  }

  void _loadOfferWatches() {
    _offerWatches
      ..clear()
      ..addAll(OfferWatch.decodeList(_prefs.getString(_offerWatchKey)));
  }
}
