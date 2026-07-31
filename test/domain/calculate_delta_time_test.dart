import 'package:basa_app_project/features/cards/domain/usecases/calculate_delta_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calculateDeltaTime', () {
    test('returns 0 when both dates are the same day', () {
      final DateTime start = DateTime(2026, 1, 1, 10);
      final DateTime end = DateTime(2026, 1, 1, 23);

      expect(calculateDeltaTime(startDate: start, endDate: end), 0);
    });

    test('returns positive days when end is after start', () {
      final DateTime start = DateTime(2026, 1, 1);
      final DateTime end = DateTime(2026, 1, 15);

      expect(calculateDeltaTime(startDate: start, endDate: end), 14);
    });

    test('returns negative days when end is before start', () {
      final DateTime start = DateTime(2026, 3, 1);
      final DateTime end = DateTime(2026, 2, 1);

      expect(calculateDeltaTime(startDate: start, endDate: end), -28);
    });

    test('counts days across year boundaries', () {
      final DateTime start = DateTime(2025, 12, 31);
      final DateTime end = DateTime(2026, 1, 2);

      expect(calculateDeltaTime(startDate: start, endDate: end), 2);
    });
  });
}
