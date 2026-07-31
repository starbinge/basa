import 'package:basa_app_project/features/cards/domain/usecases/track_per_card_timer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrackPerCardTimer', () {
    test('reports zero before it has started', () {
      expect(TrackPerCardTimer().elapsedMilliseconds, 0);
    });

    test('accumulates elapsed time while running and freezes when stopped',
        () async {
      final timer = TrackPerCardTimer();

      timer.start();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      final runningElapsed = timer.elapsedMilliseconds;

      timer.stop();
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(runningElapsed, greaterThan(0));
      expect(timer.elapsedMilliseconds, runningElapsed);
    });

    test('restarting resets the elapsed time', () async {
      final timer = TrackPerCardTimer();

      timer.start();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      timer.stop();

      timer.start();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      timer.stop();

      expect(timer.elapsedMilliseconds, lessThan(30));
    });
  });
}
