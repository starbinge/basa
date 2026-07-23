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
  QuizGameIsFinish({required this.cards});
}
