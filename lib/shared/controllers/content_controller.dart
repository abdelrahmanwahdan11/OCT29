import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class StaticContent {
  const StaticContent({
    required this.key,
    required this.titleAr,
    required this.titleEn,
    required this.contentAr,
    required this.contentEn,
  });

  final String key;
  final String titleAr;
  final String titleEn;
  final List<String> contentAr;
  final List<String> contentEn;

  String titleFor(Locale locale) =>
      locale.languageCode.toLowerCase() == 'ar' ? titleAr : titleEn;

  List<String> paragraphsFor(Locale locale) =>
      locale.languageCode.toLowerCase() == 'ar' ? contentAr : contentEn;
}

class ContentController extends ChangeNotifier {
  ContentController();

  final Map<String, StaticContent> _pages = {};
  bool _loading = false;

  bool get isLoading => _loading;
  List<StaticContent> get pages => _pages.values.toList(growable: false);
  StaticContent? pageByKey(String key) => _pages[key];

  Future<void> load() async {
    if (_loading || _pages.isNotEmpty) return;
    _loading = true;
    notifyListeners();
    try {
      final raw = await rootBundle.loadString('assets/seed/static_pages.json');
      final data = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in data.entries) {
        final value = entry.value as Map<String, dynamic>;
        _pages[entry.key] = StaticContent(
          key: entry.key,
          titleAr: value['title_ar'] as String? ?? entry.key,
          titleEn: value['title_en'] as String? ?? entry.key,
          contentAr: ((value['content_ar'] as List<dynamic>? ?? const [])).cast<String>(),
          contentEn: ((value['content_en'] as List<dynamic>? ?? const [])).cast<String>(),
        );
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
