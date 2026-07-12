class TrackPerCardTimer {
  Stopwatch? _stopwatch;

  void start() {
    _stopwatch?.reset();
    _stopwatch = Stopwatch()..start();
  }

  void stop() {
    _stopwatch?.stop();
  }

  int get elapsedMilliseconds => _stopwatch?.elapsedMilliseconds ?? 0;
}
