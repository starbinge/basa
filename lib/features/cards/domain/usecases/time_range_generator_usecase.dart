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
  final List<String> dayWeekName = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  final Map<String, List<T>> groupedByDay = {};
  for (var day in dayWeekName) {
    groupedByDay[day] = <T>[];
  }
  return groupedByDay;
}

Map<int, List<T>> getDailyObject<T>() {
  final Map<int, List<T>> groupedByDay = {};

  for (var i = 1; i <= 31; i++) {
    groupedByDay[i] = [];
  }
  return groupedByDay;
}
