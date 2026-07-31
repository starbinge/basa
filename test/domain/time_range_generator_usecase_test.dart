import 'package:basa_app_project/features/cards/domain/usecases/time_range_generator_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getMonthlyObject', () {
    test('creates 12 month buckets in the correct order', () {
      final Map<String, List<int>> result = getMonthlyObject<int>(2026);

      expect(result.length, 12);
      expect(result.keys.toList(), [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ]);
      result.forEach((_, value) => expect(value, isEmpty));
    });
  });

  group('getWeeklyObject', () {
    test('creates 4 week buckets', () {
      final Map<String, List<int>> result = getWeeklyObject<int>();

      expect(result.keys.toList(), ['1w', '2w', '3w', '4w']);
      result.forEach((_, value) => expect(value, isEmpty));
    });
  });

  group('getDailyObject', () {
    test('creates 31 buckets for a 31-day month', () {
      final Map<int, List<int>> result = getDailyObject<int>(year: 2026, month: 7);

      expect(result.length, 31);
    });

    test('creates 30 buckets for a 30-day month', () {
      final Map<int, List<int>> result = getDailyObject<int>(year: 2026, month: 6);

      expect(result.length, 30);
    });

    test('creates 28 buckets for February of a non-leap year', () {
      final Map<int, List<int>> result = getDailyObject<int>(year: 2026, month: 2);

      expect(result.length, 28);
    });

    test('creates 29 buckets for February of a leap year', () {
      final Map<int, List<int>> result = getDailyObject<int>(year: 2024, month: 2);

      expect(result.length, 29);
    });

    test('uses the current year and month when not provided', () {
      final DateTime now = DateTime.now();
      final Map<int, List<int>> result = getDailyObject<int>();

      expect(result.length, DateTime(now.year, now.month + 1, 0).day);
    });
  });
}
