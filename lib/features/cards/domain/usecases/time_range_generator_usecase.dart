import 'package:intl/intl.dart';

Map<String, List<T>> getMonthlyObject<T>(int currentYear) {
  final Map<String, List<T>> groupedByMonth = {};
  for (int i = 1; i <= 12; i++) {
    final DateTime _thisMonth = DateTime(currentYear, i);
    final String _timeName = DateFormat.MMMM('en_US').format(_thisMonth);
    groupedByMonth[_timeName] = <T>[];
  }
  return groupedByMonth;
}

Map<String, List<T>> getWeeklyObject<T>() {
  final List<String> dayWeekName = ['1w', '2w', '3w', '4w'];
  final Map<String, List<T>> groupedByDay = {};
  for (var day in dayWeekName) {
    groupedByDay[day] = <T>[];
  }
  return groupedByDay;
}

Map<int, List<T>> getDailyObject<T>({int? year, int? month}) {
  final DateTime now = DateTime.now();
  final int targetYear = year ?? now.year;
  final int targetMonth = month ?? now.month;

  final int totalDays = DateTime(targetYear, targetMonth + 1, 0).day;

  final Map<int, List<T>> groupedByDay = {};

  for (var i = 1; i <= totalDays; i++) {
    groupedByDay[i] = <T>[];
  }
  return groupedByDay;
}
