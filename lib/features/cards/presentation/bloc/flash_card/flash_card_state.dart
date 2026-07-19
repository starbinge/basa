part of 'flash_card_bloc.dart';

@immutable
sealed class FlashCardState {}

final class FlashCardInitial extends FlashCardState {}

final class FlashCardIsLoading extends FlashCardState {}

final class FLashCardIsError extends FlashCardState {
  final String errorMessage;

  FLashCardIsError({required this.errorMessage});
}

final class FLashCardIsFinished extends FlashCardState {
  final List<CardsDetailEntity> listCard;

  FLashCardIsFinished({required this.listCard});
}

final class AccuracyStatsFinished extends FlashCardState {
  final DeckAccuracyStats stats;

  AccuracyStatsFinished({required this.stats});
}

final class TimeConsumeStatsFinished extends FlashCardState {
  final DeckTimeConsume thisMonth;
  final DeckTimeConsume previousMonth;
  final List<DeckTimeConsume> monthlyAverage;
  final List<DeckTimeConsume> weeklyAverage;
  final List<DeckTimeConsume> dailyAverage;
  final List<CardsDetailEntity> top3TodayCards;
  final List<CardsDetailEntity> top3MonthlyCards;
  final List<CardsDetailEntity> top3WeeklyCards;
  final List<CardsDetailEntity> top3LeastWeeklyCards;
  final List<CardsDetailEntity> top3LeastMonthlyCards;
  final List<CardsDetailEntity> top3LeastTodayCards;
  TimeConsumeStatsFinished({
    required this.thisMonth,
    required this.previousMonth,
    required this.monthlyAverage,
    required this.weeklyAverage,
    required this.dailyAverage,
    required this.top3TodayCards,
    required this.top3MonthlyCards,
    required this.top3WeeklyCards,
    required this.top3LeastWeeklyCards,
    required this.top3LeastMonthlyCards,
    required this.top3LeastTodayCards,
  });
}
