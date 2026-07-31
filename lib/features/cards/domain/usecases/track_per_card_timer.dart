class TrackPerCardTimer {
  TrackPerCardTimer({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  DateTime? _startedAt;
  int _accumulatedMilliseconds = 0;

  void start() {
    _accumulatedMilliseconds = 0;
    _startedAt = _now();
  }

  void stop() {
    if (_startedAt != null) {
      _accumulatedMilliseconds = _now().difference(_startedAt!).inMilliseconds;
      _startedAt = null;
    }
  }

  int get elapsedMilliseconds {
    if (_startedAt != null) {
      return _accumulatedMilliseconds +
          _now().difference(_startedAt!).inMilliseconds;
    }
    return _accumulatedMilliseconds;
  }
}
