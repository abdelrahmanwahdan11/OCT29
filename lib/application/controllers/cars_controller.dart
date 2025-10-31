import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/entities/car.dart';
import '../../domain/entities/comparison_set.dart';
import '../../domain/enums/condition.dart';
import '../../domain/enums/fuel_type.dart';
import '../../domain/enums/transmission.dart';
import '../../domain/repositories/car_repository.dart';
import 'rebuild_controller.dart';

class CarsFilter {
  CarsFilter({
    this.brands = const <String>{},
    this.condition,
    this.minPrice,
    this.maxPrice,
    this.minYear,
    this.maxYear,
    this.minMileage,
    this.maxMileage,
    this.fuels = const <FuelType>{},
    this.transmissions = const <Transmission>{},
    this.seats = const <int>{},
    this.city,
  });

  final Set<String> brands;
  final Condition? condition;
  final double? minPrice;
  final double? maxPrice;
  final int? minYear;
  final int? maxYear;
  final int? minMileage;
  final int? maxMileage;
  final Set<FuelType> fuels;
  final Set<Transmission> transmissions;
  final Set<int> seats;
  final String? city;

  factory CarsFilter.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CarsFilter();
    }
    return CarsFilter(
      brands: (json['brands'] as List<dynamic>? ?? <dynamic>[]).cast<String>().toSet(),
      condition: json['condition'] == null ? null : ConditionX.fromString(json['condition'] as String),
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      minYear: json['minYear'] as int?,
      maxYear: json['maxYear'] as int?,
      minMileage: json['minMileage'] as int?,
      maxMileage: json['maxMileage'] as int?,
      fuels: (json['fuels'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic value) => FuelTypeX.fromString(value as String))
          .toSet(),
      transmissions: (json['transmissions'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic value) => TransmissionX.fromString(value as String))
          .toSet(),
      seats: (json['seats'] as List<dynamic>? ?? <dynamic>[]).map((dynamic value) => value as int).toSet(),
      city: json['city'] as String?,
    );
  }

  CarsFilter copyWith({
    Set<String>? brands,
    Condition? condition,
    bool clearCondition = false,
    double? minPrice,
    double? maxPrice,
    int? minYear,
    int? maxYear,
    int? minMileage,
    int? maxMileage,
    Set<FuelType>? fuels,
    Set<Transmission>? transmissions,
    Set<int>? seats,
    String? city,
  }) {
    return CarsFilter(
      brands: brands ?? this.brands,
      condition: clearCondition ? null : condition ?? this.condition,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      minMileage: minMileage ?? this.minMileage,
      maxMileage: maxMileage ?? this.maxMileage,
      fuels: fuels ?? this.fuels,
      transmissions: transmissions ?? this.transmissions,
      seats: seats ?? this.seats,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'brands': brands.toList(),
      'condition': condition?.storageValue,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'minYear': minYear,
      'maxYear': maxYear,
      'minMileage': minMileage,
      'maxMileage': maxMileage,
      'fuels': fuels.map((fuel) => fuel.storageValue).toList(),
      'transmissions': transmissions.map((transmission) => transmission.storageValue).toList(),
      'seats': seats.toList(),
      'city': city,
    };
  }

  bool get isEmpty {
    return brands.isEmpty &&
        condition == null &&
        minPrice == null &&
        maxPrice == null &&
        minYear == null &&
        maxYear == null &&
        minMileage == null &&
        maxMileage == null &&
        fuels.isEmpty &&
        transmissions.isEmpty &&
        seats.isEmpty &&
        (city == null || city!.isEmpty);
  }
}

class CarsController extends ChangeNotifier {
  CarsController(this._repository)
      : listController = RebuildController<List<Car>>(<Car>[]),
        featuredController = RebuildController<List<Car>>(<Car>[]),
        compareSet = ComparisonSet();

  final CarRepository _repository;

  final RebuildController<List<Car>> listController;
  final RebuildController<List<Car>> featuredController;
  final ComparisonSet compareSet;

  final ScrollController scrollController = ScrollController();

  bool _loading = false;
  bool get isLoading => _loading;

  bool _loadingMore = false;
  bool get isLoadingMore => _loadingMore;

  int _currentPage = 0;
  static const int pageSize = 10;
  String _searchTerm = '';
  CarsFilter _filter = CarsFilter();

  final List<Car> _allCars = <Car>[];
  final List<Car> _visibleCars = <Car>[];

  List<Car> get visibleCars => List.unmodifiable(_visibleCars);
  CarsFilter get filter => _filter;
  String get searchTerm => _searchTerm;

  List<String> _favoriteIds = <String>[];
  List<String> get favoriteIds => _favoriteIds;

  Car? findById(String id) {
    try {
      return _allCars.firstWhere((car) => car.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> initialize() async {
    if (_loading) return;
    _loading = true;
    notifyListeners();
    final cars = await _repository.fetchCars();
    _allCars
      ..clear()
      ..addAll(cars);
    _favoriteIds = await _repository.loadFavorites();
    compareSet
      ..clear()
      ..ids.addAll(await _repository.loadCompare());
    _applyFeatured();
    _applyFilters(resetPagination: true);
    _loading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _loading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 600));
    await _repository.cacheCars(_allCars);
    _applyFeatured();
    _applyFilters(resetPagination: true);
    _loading = false;
    notifyListeners();
  }

  void updateSearch(String value) {
    _searchTerm = value;
    _applyFilters(resetPagination: true);
  }

  void updateFilter(CarsFilter filter) {
    _filter = filter;
    _applyFilters(resetPagination: true);
  }

  void clearFilter() {
    _filter = CarsFilter();
    _applyFilters(resetPagination: true);
  }

  void clearFilters() => clearFilter();

  void setFilterFromSavedSearch(CarsFilter filter, {String? searchTerm}) {
    _filter = filter;
    if (searchTerm != null) {
      _searchTerm = searchTerm;
    }
    _applyFilters(resetPagination: true);
    notifyListeners();
  }

  Future<void> toggleFavorite(String carId) async {
    if (_favoriteIds.contains(carId)) {
      _favoriteIds.remove(carId);
    } else {
      _favoriteIds.add(carId);
    }
    await _repository.saveFavorites(_favoriteIds);
    _applyFilters(resetPagination: false);
    notifyListeners();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<bool> toggleCompare(String id) async {
    bool success;
    if (compareSet.ids.contains(id)) {
      compareSet.remove(id);
      success = true;
    } else {
      success = compareSet.add(id);
    }
    await _repository.saveCompare(compareSet.ids);
    notifyListeners();
    return success;
  }

  void _applyFilters({required bool resetPagination}) {
    Iterable<Car> filtered = _allCars;
    if (_filter.brands.isNotEmpty) {
      filtered = filtered.where((car) => _filter.brands.contains(car.brand));
    }
    if (_filter.condition != null) {
      filtered = filtered.where((car) => car.condition == _filter.condition);
    }
    if (_filter.minPrice != null) {
      filtered = filtered.where((car) => car.price >= _filter.minPrice!);
    }
    if (_filter.maxPrice != null) {
      filtered = filtered.where((car) => car.price <= _filter.maxPrice!);
    }
    if (_filter.minYear != null) {
      filtered = filtered.where((car) => car.year >= _filter.minYear!);
    }
    if (_filter.maxYear != null) {
      filtered = filtered.where((car) => car.year <= _filter.maxYear!);
    }
    if (_filter.minMileage != null) {
      filtered = filtered.where((car) => car.mileageKm >= _filter.minMileage!);
    }
    if (_filter.maxMileage != null) {
      filtered = filtered.where((car) => car.mileageKm <= _filter.maxMileage!);
    }
    if (_filter.fuels.isNotEmpty) {
      filtered = filtered.where((car) => _filter.fuels.contains(car.fuel));
    }
    if (_filter.transmissions.isNotEmpty) {
      filtered = filtered.where((car) => _filter.transmissions.contains(car.transmission));
    }
    if (_filter.seats.isNotEmpty) {
      filtered = filtered.where((car) => _filter.seats.contains(car.seats));
    }
    if (_filter.city != null && _filter.city!.isNotEmpty) {
      filtered = filtered.where((car) => car.locationCity.toLowerCase().contains(_filter.city!.toLowerCase()));
    }
    if (_searchTerm.isNotEmpty) {
      final term = _searchTerm.toLowerCase();
      filtered = filtered.where((car) {
        return car.brand.toLowerCase().contains(term) ||
            car.model.toLowerCase().contains(term) ||
            car.locationCity.toLowerCase().contains(term) ||
            car.description.toLowerCase().contains(term) ||
            car.year.toString().contains(term) ||
            car.fuel.labelEn.toLowerCase().contains(term) ||
            car.transmission.labelEn.toLowerCase().contains(term);
      });
    }

    final List<Car> filteredList = filtered.toList()
      ..sort((a, b) => b.isFeatured.compareTo(a.isFeatured));

    if (resetPagination) {
      _currentPage = 0;
      _visibleCars.clear();
    }

    final int start = _currentPage * pageSize;
    final int end = start + pageSize;
    final slice = filteredList.skip(start).take(pageSize).toList();
    if (resetPagination) {
      _visibleCars
        ..clear()
        ..addAll(slice);
    } else {
      _visibleCars.addAll(slice);
    }
    listController.update(List<Car>.from(_visibleCars));
  }

  Future<void> loadMore() async {
    if (_loadingMore) return;
    final totalPages = (_allCars.length / pageSize).ceil();
    if (_currentPage + 1 >= totalPages) {
      return;
    }
    _loadingMore = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 320));
    _currentPage += 1;
    _applyFilters(resetPagination: false);
    _loadingMore = false;
    notifyListeners();
  }

  void _applyFeatured() {
    final featured = _allCars.where((car) => car.isFeatured).take(6).toList();
    featuredController.update(featured);
  }

  String buildAiExplainText(Car car) {
    final buffer = StringBuffer();
    buffer.write('${car.brand} ${car.model} packs ${car.horsepower} hp with a top speed of ${car.topSpeedKmh} km/h, ');
    buffer.write('making it a ${car.condition.labelEn.toLowerCase()} ${car.fuel.labelEn.toLowerCase()} option');
    if (car.mileageKm > 0) {
      buffer.write(' with ${car.mileageKm} km on the clock');
    }
    buffer.writeln('.');
    buffer.writeln('Expect ${car.transmission.labelEn.toLowerCase()} shifts and a 0-100 sprint in ${car.acceleration0100}s.');
    if (car.batteryRangeKm != null) {
      buffer.writeln('Battery range comes in at about ${car.batteryRangeKm} km.');
    }
    buffer.writeln('Ideal for drivers in ${car.locationCity} wanting a ${car.seats}-seater with ${car.drivetrain} traction.');
    buffer.write('Tip: compare maintenance history and schedule a ${car.fuel == FuelType.electric ? 'charge' : 'test drive'} before closing.');
    return buffer.toString();
  }

  void disposeControllers() {
    listController.dispose();
    featuredController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
