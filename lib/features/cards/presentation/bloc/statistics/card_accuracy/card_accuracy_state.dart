part of 'card_accuracy_bloc.dart';

@immutable
sealed class CardAccuracyState {}

final class CardAccuracyInitial extends CardAccuracyState {}

final class CardAccuracyLoading extends CardAccuracyState {}

final class CardAccuracyError extends CardAccuracyState {
  final String errorMessage;
  CardAccuracyError({required this.errorMessage});
}

final class AccuracySummaryLoaded extends CardAccuracyState {
  final DeckAccuracy thisMonthAccuracy;
  final DeckAccuracy previousMonthAccuracy;

  AccuracySummaryLoaded({
    required this.thisMonthAccuracy,
    required this.previousMonthAccuracy,
  });
}

final class AccuracyDetailLoaded extends CardAccuracyState {
  final DeckAccuracy thisMonthAccuracy;
  final DeckAccuracy previousMonthAccuracy;
  final List<DeckAccuracy> monthlyAccuracy;
  final List<DeckAccuracy> weeklyAccuracy;
  final List<DeckAccuracy> dailyAccuracy;
  final List<CardsDetailEntity> top3MonthlyMostAccurate;
  final List<CardsDetailEntity> top3WeeklyMostAccurate;
  final List<CardsDetailEntity> top3TodayMostAccurate;
  final List<CardsDetailEntity> top3MonthlyLeastAccurate;
  final List<CardsDetailEntity> top3WeeklyLeastAccurate;
  final List<CardsDetailEntity> top3TodayLeastAccurate;

  AccuracyDetailLoaded({
    required this.thisMonthAccuracy,
    required this.previousMonthAccuracy,
    required this.monthlyAccuracy,
    required this.weeklyAccuracy,
    required this.dailyAccuracy,
    required this.top3MonthlyMostAccurate,
    required this.top3WeeklyMostAccurate,
    required this.top3TodayMostAccurate,
    required this.top3MonthlyLeastAccurate,
    required this.top3WeeklyLeastAccurate,
    required this.top3TodayLeastAccurate,
  });
}
