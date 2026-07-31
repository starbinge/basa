import 'package:basa_app_project/features/cards/domain/usecases/track_per_card_timer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DateTime fakeTime;

  DateTime fakeNow() => fakeTime;

  TrackPerCardTimer buildTimer() {
    return TrackPerCardTimer(now: fakeNow);
  }

  setUp(() {
    fakeTime = DateTime(2026, 1, 1);
  });

  group('TrackPerCardTimer', () {
    test('reports zero before it has started', () {
      expect(buildTimer().elapsedMilliseconds, 0);
    });

    test('accumulates elapsed time while running and freezes when stopped',
        () {
      final timer = buildTimer();

      timer.start();
      fakeTime = fakeTime.add(const Duration(milliseconds: 30));
      expect(timer.elapsedMilliseconds, 30);

      timer.stop();
      fakeTime = fakeTime.add(const Duration(milliseconds: 30));

      expect(timer.elapsedMilliseconds, 30);
    });

    test('restarting resets the elapsed time', () {
      final timer = buildTimer();

      timer.start();
      fakeTime = fakeTime.add(const Duration(milliseconds: 30));
      timer.stop();
      expect(timer.elapsedMilliseconds, 30);

      timer.start();
      fakeTime = fakeTime.add(const Duration(milliseconds: 5));
      timer.stop();

      expect(timer.elapsedMilliseconds, 5);
    });

    test('keeps counting after a stop that is followed by another start', () {
      final timer = buildTimer();

      timer.start();
      fakeTime = fakeTime.add(const Duration(milliseconds: 10));
      timer.stop();
      fakeTime = fakeTime.add(const Duration(milliseconds: 100));

      timer.start();
      fakeTime = fakeTime.add(const Duration(milliseconds: 7));

      expect(timer.elapsedMilliseconds, 7);
    });
  });
}
