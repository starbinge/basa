int calculateDeltaTime({
  required DateTime startDate,
  required DateTime endDate,
}) {
  return endDate.difference(startDate).inDays;
}
