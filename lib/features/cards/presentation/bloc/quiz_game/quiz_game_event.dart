part of 'quiz_game_bloc.dart';

@immutable
sealed class QuizGameEvent {}

class GeneratingQuizGameQuestions extends QuizGameEvent {
  final List<CardsDetailEntity> listCards;
  final int startIndex;

  GeneratingQuizGameQuestions({required this.listCards, this.startIndex = 0});
}

class AnsweringQuestion extends QuizGameEvent {
  final FlashcardAnswerEnum answer;

  final CardsDetailEntity selectedCard;

  final int timeMs;

  AnsweringQuestion({
    required FlashcardAnswerEnum this.answer,
    required CardsDetailEntity this.selectedCard,
    required this.timeMs,
  });
}
