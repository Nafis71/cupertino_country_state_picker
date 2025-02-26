import 'dart:async';
import 'dart:ui';
/// This is used for limiting the search function call
class PickerDeBouncer {
  /// Indicates delay between calls
  final Duration delay;
  Timer? _timer;
  ///
  PickerDeBouncer({required this.delay});

  /// Execute function call at a given delay
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Stops the timer
  dispose() {
    _timer?.cancel();
  }
}
