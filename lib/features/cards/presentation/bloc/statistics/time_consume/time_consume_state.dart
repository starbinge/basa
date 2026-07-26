part of 'time_consume_bloc.dart';

@immutable
sealed class TimeConsumeState {}

final class TimeConsumeInitial extends TimeConsumeState {}

final class TimeConsumeLoading extends TimeConsumeState {}

final class TimeConsumeError extends TimeConsumeState {
  final String errorMessage;
  TimeConsumeError({required this.errorMessage});
}

final class StreakDataLoaded extends TimeConsumeState {
  final List<TimeConsumeEntity> streakData;
  StreakDataLoaded({required this.streakData});
}

final class TimeConsumeDetailLoaded extends TimeConsumeState {
  final TimeConsumeEntity thisMonthTimeConsume;
  final TimeConsumeEntity previousMonthTimeConsume;
  final List<TimeConsumeEntity> monthlyTimeConsume;
  final List<TimeConsumeEntity> weeklyTimeConsume;
  final List<TimeConsumeEntity> dailyTimeConsume;
  final List<CardsDetailEntity> top3MonthlyMostTimeConsume;
  final List<CardsDetailEntity> top3WeeklyMostTimeConsume;
  final List<CardsDetailEntity> top3TodayMostTimeConsume;
  final List<CardsDetailEntity> top3MonthlyLeastTimeConsume;
  final List<CardsDetailEntity> top3WeeklyLeastTimeConsume;
  final List<CardsDetailEntity> top3TodayLeastTimeConsume;

  TimeConsumeDetailLoaded({
    required this.thisMonthTimeConsume,
    required this.previousMonthTimeConsume,
    required this.monthlyTimeConsume,
    required this.weeklyTimeConsume,
    required this.dailyTimeConsume,
    required this.top3MonthlyMostTimeConsume,
    required this.top3WeeklyMostTimeConsume,
    required this.top3TodayMostTimeConsume,
    required this.top3MonthlyLeastTimeConsume,
    required this.top3WeeklyLeastTimeConsume,
    required this.top3TodayLeastTimeConsume,
  });
}
