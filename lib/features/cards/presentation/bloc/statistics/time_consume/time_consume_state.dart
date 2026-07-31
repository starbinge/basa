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
  final List<TimeConsumeEntity> dailyTimeConsume;
  final List<TopCardsTimeConsumeEntity>? mostTimeConsumingCards;
  final int? totalCard;
  final TimeUnit? avgTime;
  final TimeUnit? totalTime;

  TimeConsumeDetailLoaded({
    required this.thisMonthTimeConsume,
    required this.previousMonthTimeConsume,
    required this.monthlyTimeConsume,
    required this.dailyTimeConsume,
    this.mostTimeConsumingCards,
    this.totalCard,
    this.avgTime,
    this.totalTime,
  });

  TimeConsumeDetailLoaded copyWith({
    TimeConsumeEntity? thisMonthTimeConsume,
    TimeConsumeEntity? previousMonthTimeConsume,
    List<TimeConsumeEntity>? monthlyTimeConsume,
    List<TimeConsumeEntity>? dailyTimeConsume,
    List<TopCardsTimeConsumeEntity>? mostTimeConsumingCards,
    int? totalCard,
    TimeUnit? avgTime,
    TimeUnit? totalTime,
  }) {
    return TimeConsumeDetailLoaded(
      thisMonthTimeConsume: thisMonthTimeConsume ?? this.thisMonthTimeConsume,
      previousMonthTimeConsume:
          previousMonthTimeConsume ?? this.previousMonthTimeConsume,
      monthlyTimeConsume: monthlyTimeConsume ?? this.monthlyTimeConsume,
      dailyTimeConsume: dailyTimeConsume ?? this.dailyTimeConsume,
      totalCard: totalCard ?? this.totalCard,
      mostTimeConsumingCards:
          mostTimeConsumingCards ?? this.mostTimeConsumingCards,
      avgTime: avgTime ?? this.avgTime,
      totalTime: totalTime ?? this.totalTime,
    );
  }
}
