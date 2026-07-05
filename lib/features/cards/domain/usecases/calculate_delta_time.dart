int calculateDeltaTime({
  required DateTime startDate,
  required DateTime endDate,
}) {
  return startDate.difference(endDate).inDays;
}
