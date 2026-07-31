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

  final List<DeckAccuracy> dailyAccuracy;
  final int? totalCard;
  final int? avgAccuracy;
  final TimeUnit? totalTime;
  final List<CardsDetailEntity>? top3LeastAccurate;

  AccuracyDetailLoaded({
    required this.thisMonthAccuracy,
    required this.previousMonthAccuracy,
    required this.monthlyAccuracy,

    required this.dailyAccuracy,
    this.totalCard,
    this.avgAccuracy,
    this.totalTime,
    this.top3LeastAccurate,
  });

  AccuracyDetailLoaded copyWith({
    final DeckAccuracy? thisMonthAccuracy,
    final DeckAccuracy? previousMonthAccuracy,
    final List<DeckAccuracy>? monthlyAccuracy,

    final List<DeckAccuracy>? dailyAccuracy,
    final int? totalCard,
    final int? avgAccuracy,
    final TimeUnit? totalTime,
    final List<CardsDetailEntity>? top3LeastAccurate,
  }) {
    return AccuracyDetailLoaded(
      thisMonthAccuracy: thisMonthAccuracy ?? this.thisMonthAccuracy,
      previousMonthAccuracy:
          previousMonthAccuracy ?? this.previousMonthAccuracy,
      monthlyAccuracy: monthlyAccuracy ?? this.monthlyAccuracy,
      dailyAccuracy: dailyAccuracy ?? this.dailyAccuracy,
      top3LeastAccurate: top3LeastAccurate ?? this.top3LeastAccurate,
      totalCard: totalCard ?? this.totalCard,
      avgAccuracy: avgAccuracy ?? this.avgAccuracy,
      totalTime: totalTime ?? this.totalTime,
    );
  }
}

final class AccuracyTopCardsLoaded extends CardAccuracyState {
  final int totalCard;
  final int avgAccuracy;
  final TimeUnit totalTime;
  final List<CardsDetailEntity> top3LeastAccurate;

  AccuracyTopCardsLoaded({
    required this.top3LeastAccurate,
    required this.totalCard,
    required this.avgAccuracy,
    required this.totalTime,
  });
}
