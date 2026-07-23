int getStartOfNextMonthEpoch({required DateTime time}) {
  //
  final startOfNextMonth = DateTime(time.year, time.month + 1, 1);
  return startOfNextMonth.millisecondsSinceEpoch;
}

int getStartOfMonthEpoch({required DateTime time}) {
  final startOfMonth = DateTime(time.year, time.month, 1);
  return startOfMonth.millisecondsSinceEpoch;
}

int getStartOfPreviousMonthEpoch({required DateTime time}) {
  final startOfPreviousMonth = DateTime(time.year, time.month - 1, 1);
  return startOfPreviousMonth.millisecondsSinceEpoch;
}

int getStartOfWeekEpoch({required DateTime time}) {
  final startOfWeek = time.subtract(Duration(days: time.weekday - 1));
  return DateTime(
    startOfWeek.year,
    startOfWeek.month,
    startOfWeek.day,
  ).millisecondsSinceEpoch;
}

int getEndOfWeekEpoch({required DateTime time}) {
  return getStartOfWeekEpoch(time: time) + (7 * 24 * 60 * 60 * 1000);
}

int getStartOfTodayEpoch({required DateTime time}) {
  return DateTime(time.year, time.month, time.day).millisecondsSinceEpoch;
}

int getEndOfTodayEpoch({required DateTime time}) {
  return DateTime(time.year, time.month, time.day + 1).millisecondsSinceEpoch;
}
