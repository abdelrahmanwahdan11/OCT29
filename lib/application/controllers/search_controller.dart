import 'package:flutter/foundation.dart';

class SearchController extends ChangeNotifier {
  String _query = '';
  String get query => _query;

  void update(String value) {
    _query = value;
    notifyListeners();
  }

  void clear() {
    _query = '';
    notifyListeners();
  }
}
