part of 'quiz_game_bloc.dart';

@immutable
sealed class QuizGameState {}

final class QuizGameInitial extends QuizGameState {}

final class QuizGameIsLoading extends QuizGameState {}

final class QuizGameIsError extends QuizGameState {
  final String errorMessage;
  QuizGameIsError({required this.errorMessage});
}

final class QuizGameIsFinish extends QuizGameState {
  final List<QuizGameEntity> cards;
  final int? totalQuestion;

  final int? activeQuestion;
  final int? answeredQuestion;

  QuizGameIsFinish({
    required this.cards,
    this.totalQuestion,
    this.activeQuestion,
    this.answeredQuestion,
  });

  QuizGameIsFinish copyWith({
    List<QuizGameEntity>? cards,
    int? totalQuestion,

    int? activeQuestion,
    int? answeredQuestion,
  }) {
    return QuizGameIsFinish(
      cards: cards ?? this.cards,
      totalQuestion: totalQuestion ?? this.totalQuestion,
      activeQuestion: activeQuestion ?? this.activeQuestion,
      answeredQuestion: answeredQuestion ?? this.answeredQuestion,
    );
  }
}
