class DeckAccuracyStats {
  final DeckAccuracy thisMonthDeckAccuracy;
  final DeckAccuracy previousMonthDeckAccuracy;

  final List<DeckAccuracy> monthlyList;
  final List<DeckAccuracy> dailyAccuracyList;

  DeckAccuracyStats({
    required this.thisMonthDeckAccuracy,
    required this.previousMonthDeckAccuracy,

    required this.monthlyList,
    required this.dailyAccuracyList,
  });
}

class DeckAccuracy {
  final String timeName;
  final int accuracyNumber;

  DeckAccuracy({required this.timeName, required this.accuracyNumber});
}
