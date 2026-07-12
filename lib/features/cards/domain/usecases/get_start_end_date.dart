int getStartOfNextMonthEpoch({required DateTime time}) {
  //
  final startOfNextMonth = DateTime(time.year, time.month + 1, 1);
  return startOfNextMonth.millisecondsSinceEpoch;
}

int getStartOfMonthEpoch({required DateTime time}) {
  final startOfMonth = DateTime(time.year, time.month, 1);
  return startOfMonth.millisecondsSinceEpoch;
}
