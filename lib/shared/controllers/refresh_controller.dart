import 'dart:async';

class RefreshController {
  RefreshController({required this.debounceMs});

  final int debounceMs;
  Timer? _timer;

  Future<void> perform(Future<void> Function() action) async {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    final completer = Completer<void>();
    _timer = Timer(Duration(milliseconds: debounceMs), () async {
      await action();
      completer.complete();
    });
    return completer.future;
  }

  void dispose() {
    _timer?.cancel();
  }
}
