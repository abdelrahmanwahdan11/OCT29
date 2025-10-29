import 'package:flutter/material.dart';

import '../utils/search_index.dart';

class SearchController extends ChangeNotifier {
  final TextEditingController queryController = TextEditingController();
  SearchScope scope = SearchScope.all;

  String get query => queryController.text;

  void setScope(SearchScope newScope) {
    if (newScope == scope) return;
    scope = newScope;
    notifyListeners();
  }

  void setQuery(String value) {
    if (value == query) return;
    queryController.text = value;
    notifyListeners();
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }
}
