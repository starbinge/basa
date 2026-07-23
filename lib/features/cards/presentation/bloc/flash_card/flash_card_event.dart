part of 'flash_card_bloc.dart';

@immutable
sealed class FlashCardEvent {}

class GenerateFlashCard extends FlashCardEvent {
  final List<CardsDetailEntity> listCard;
  final int startIndex;

  GenerateFlashCard({required this.listCard, this.startIndex = 0});
}

class AnsweringFlashCard extends FlashCardEvent {
  final FlashcardAnswerEnum answer;

  final CardsDetailEntity selectedCard;

  final int timeMs;

  AnsweringFlashCard({
    required FlashcardAnswerEnum this.answer,
    required CardsDetailEntity this.selectedCard,
    required this.timeMs,
  });
}

class GettingAccuracyStats extends FlashCardEvent {}

class GettingTimeConsumeStats extends FlashCardEvent {}
