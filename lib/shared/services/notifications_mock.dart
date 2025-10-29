import 'package:flutter/foundation.dart';

class NotificationsMock {
  final ValueNotifier<List<String>> log = ValueNotifier(const []);

  void push(String message) {
    final entries = List<String>.from(log.value)..add(message);
    log.value = entries;
  }
}
