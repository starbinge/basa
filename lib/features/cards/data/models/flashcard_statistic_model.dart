import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';

class DeckAccuracyStats {
  final DeckAccuracy thisMonthDeckAccuracy;
  final DeckAccuracy previousMonthDeckAccuracy;
  final List<DeckAccuracy> weeklyList;
  final List<DeckAccuracy> monthlyList;
  final List<DeckAccuracy> dailyAccuracyList;
  final List<CardsDetailEntity> top3TodayMostAccurate;
  final List<CardsDetailEntity> top3TodayLeastAccurate;
  final List<CardsDetailEntity> top3WeeklyMostAccurate;
  final List<CardsDetailEntity> top3WeeklyLeastAccurate;
  final List<CardsDetailEntity> top3MonthlyMostAccurate;
  final List<CardsDetailEntity> top3MonthlyLeastAccurate;

  DeckAccuracyStats({
    required this.thisMonthDeckAccuracy,
    required this.previousMonthDeckAccuracy,
    required this.weeklyList,
    required this.monthlyList,
    required this.dailyAccuracyList,
    required this.top3TodayMostAccurate,
    required this.top3TodayLeastAccurate,
    required this.top3WeeklyMostAccurate,
    required this.top3WeeklyLeastAccurate,
    required this.top3MonthlyMostAccurate,
    required this.top3MonthlyLeastAccurate,
  });
}

class DeckAccuracy {
  final String timeName;
  final int accuracyNumber;

  DeckAccuracy({required this.timeName, required this.accuracyNumber});
}
