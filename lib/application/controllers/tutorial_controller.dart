import 'package:flutter/material.dart';

class TutorialController extends ChangeNotifier {
  final List<String> steps = const <String>[
    'home.brands_chips',
    'home.search_card',
    'list.filter_button',
    'details.viewer_3d',
    'details.compare_button',
    'compare.topbar',
    'mycar.offer_watch',
  ];

  int _currentIndex = 0;
  bool _visible = false;

  int get currentIndex => _currentIndex;
  bool get isVisible => _visible;
  String get currentStep => steps[_currentIndex];

  void start() {
    _currentIndex = 0;
    _visible = true;
    notifyListeners();
  }

  void next() {
    if (_currentIndex < steps.length - 1) {
      _currentIndex += 1;
    } else {
      _visible = false;
    }
    notifyListeners();
  }

  void close() {
    _visible = false;
    notifyListeners();
  }
}
