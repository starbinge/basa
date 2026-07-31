import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getStartOfMonthEpoch', () {
    test('returns first day of the same month at 00:00', () {
      final DateTime time = DateTime(2026, 7, 15, 14, 30);
      final DateTime expected = DateTime(2026, 7, 1);

      expect(
        getStartOfMonthEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });
  });

  group('getStartOfNextMonthEpoch', () {
    test('returns first day of the following month', () {
      final DateTime time = DateTime(2026, 7, 15);
      final DateTime expected = DateTime(2026, 8, 1);

      expect(
        getStartOfNextMonthEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });

    test('wraps to the next year when month is December', () {
      final DateTime time = DateTime(2026, 12, 15);
      final DateTime expected = DateTime(2027, 1, 1);

      expect(
        getStartOfNextMonthEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });
  });

  group('getStartOfPreviousMonthEpoch', () {
    test('returns first day of the previous month', () {
      final DateTime time = DateTime(2026, 7, 15);
      final DateTime expected = DateTime(2026, 6, 1);

      expect(
        getStartOfPreviousMonthEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });

    test('wraps to the previous year when month is January', () {
      final DateTime time = DateTime(2026, 1, 15);
      final DateTime expected = DateTime(2025, 12, 1);

      expect(
        getStartOfPreviousMonthEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });
  });

  group('getStartOfWeekEpoch', () {
    test('returns Monday of the same week', () {
      // 2026-07-16 is a Thursday (weekday 4).
      final DateTime time = DateTime(2026, 7, 16);
      final DateTime expected = DateTime(2026, 7, 13);

      expect(
        getStartOfWeekEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });

    test('returns the same day when it is already Monday', () {
      final DateTime time = DateTime(2026, 7, 13);

      expect(
        getStartOfWeekEpoch(time: time),
        time.millisecondsSinceEpoch,
      );
    });
  });

  group('getEndOfWeekEpoch', () {
    test('returns start of next week', () {
      final DateTime time = DateTime(2026, 7, 16);
      final DateTime expected = DateTime(2026, 7, 20);

      expect(
        getEndOfWeekEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });
  });

  group('getStartOfTodayEpoch / getEndOfTodayEpoch', () {
    test('start of today ignores time of day', () {
      final DateTime time = DateTime(2026, 7, 16, 23, 59);
      final DateTime expected = DateTime(2026, 7, 16);

      expect(
        getStartOfTodayEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });

    test('end of today is start of tomorrow', () {
      final DateTime time = DateTime(2026, 7, 16, 1, 0);
      final DateTime expected = DateTime(2026, 7, 17);

      expect(
        getEndOfTodayEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });
  });

  group('getStartOfYearEpoch / getEndOfYearEpoch', () {
    test('start of year is January 1st', () {
      final DateTime time = DateTime(2026, 7, 16);
      final DateTime expected = DateTime(2026, 1, 1);

      expect(
        getStartOfYearEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });

    test('end of year is January 1st of the next year', () {
      final DateTime time = DateTime(2026, 7, 16);
      final DateTime expected = DateTime(2027, 1, 1);

      expect(
        getEndOfYearEpoch(time: time),
        expected.millisecondsSinceEpoch,
      );
    });
  });
}
