import 'package:flutter/foundation.dart';

class RebuildController<T> extends ValueNotifier<T> {
  RebuildController(super.value);

  void update(T newValue) {
    value = newValue;
    notifyListeners();
  }
}
