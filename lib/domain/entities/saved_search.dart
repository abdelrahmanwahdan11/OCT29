import 'dart:convert';

import '../../application/controllers/cars_controller.dart';

class SavedSearch {
  SavedSearch({
    required this.id,
    required this.query,
    required this.filter,
    required this.createdAt,
  });

  final String id;
  final String query;
  final CarsFilter filter;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'query': query,
      'filter': filter.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SavedSearch.fromJson(Map<String, dynamic> json) {
    return SavedSearch(
      id: json['id'] as String,
      query: json['query'] as String,
      filter: CarsFilter.fromJson(json['filter'] as Map<String, dynamic>?),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  static List<SavedSearch> decodeList(String? value) {
    if (value == null || value.isEmpty) return <SavedSearch>[];
    final List<dynamic> jsonList = json.decode(value) as List<dynamic>;
    return jsonList
        .map((dynamic item) => SavedSearch.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static String encodeList(List<SavedSearch> searches) {
    final data = searches.map((e) => e.toJson()).toList();
    return json.encode(data);
  }
}
