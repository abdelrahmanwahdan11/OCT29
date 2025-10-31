import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/saved_search.dart';
import 'cars_controller.dart';

class SavedSearchController extends ChangeNotifier {
  SavedSearchController(this._prefs, this._carsController) {
    _load();
  }

  final SharedPreferences _prefs;
  final CarsController _carsController;

  static const String storageKey = 'data.saved_searches';

  final List<SavedSearch> _searches = <SavedSearch>[];
  List<SavedSearch> get searches => List.unmodifiable(_searches);

  void _load() {
    final value = _prefs.getString(storageKey);
    _searches
      ..clear()
      ..addAll(SavedSearch.decodeList(value));
    notifyListeners();
  }

  Future<void> _persist() async {
    final value = SavedSearch.encodeList(_searches);
    await _prefs.setString(storageKey, value);
  }

  Future<void> addSearch(String query, CarsFilter filter) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final search = SavedSearch(
      id: id,
      query: query,
      filter: filter,
      createdAt: DateTime.now(),
    );
    _searches.insert(0, search);
    await _persist();
    notifyListeners();
  }

  Future<void> renameSearch(String id, String newQuery) async {
    final index = _searches.indexWhere((search) => search.id == id);
    if (index == -1) return;
    _searches[index] = SavedSearch(
      id: _searches[index].id,
      query: newQuery,
      filter: _searches[index].filter,
      createdAt: _searches[index].createdAt,
    );
    await _persist();
    notifyListeners();
  }

  Future<void> deleteSearch(String id) async {
    _searches.removeWhere((search) => search.id == id);
    await _persist();
    notifyListeners();
  }

  void applySearch(SavedSearch search) {
    _carsController.setFilterFromSavedSearch(search.filter, searchTerm: search.query);
    notifyListeners();
  }
}
