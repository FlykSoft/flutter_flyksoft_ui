import 'dart:async';
import 'dart:ui';

class Debouncer {
  Duration delay;
  Timer? _timer;
  VoidCallback? _callback;

  Debouncer({
    this.delay = const Duration(milliseconds: 700),
  });

  void debounce(final VoidCallback callback) {
    _callback = callback;
    cancel();
    _timer = Timer(delay, _flush);
  }

  void cancel() {
    _timer?.cancel();
  }

  void _flush() {
    _callback?.call();
    cancel();
  }
}
