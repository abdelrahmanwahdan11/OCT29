import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/car.dart';
import 'cars_controller.dart';

class RecentViewsController extends ChangeNotifier {
  RecentViewsController(this._prefs, this._carsController) {
    _ids = List<String>.from(_prefs.getStringList(_storageKey) ?? <String>[]);
  }

  static const String _storageKey = 'data.recent_views';

  final SharedPreferences _prefs;
  final CarsController _carsController;

  List<String> _ids = <String>[];

  List<Car> get recentCars {
    return _ids
        .map(_carsController.findById)
        .whereType<Car>()
        .toList(growable: false);
  }

  Future<void> _persist() async {
    await _prefs.setStringList(_storageKey, _ids);
  }

  Future<void> recordView(String carId) async {
    _ids.remove(carId);
    _ids.insert(0, carId);
    if (_ids.length > 20) {
      _ids = _ids.sublist(0, 20);
    }
    await _persist();
    notifyListeners();
  }

  Future<void> clear() async {
    _ids.clear();
    await _persist();
    notifyListeners();
  }
}
