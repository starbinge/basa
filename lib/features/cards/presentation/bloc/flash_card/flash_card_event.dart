part of 'flash_card_bloc.dart';

@immutable
sealed class FlashCardEvent {}

class GenerateFlashCard extends FlashCardEvent {
  final List<CardsDetailEntity> listCard;

  GenerateFlashCard({required this.listCard});
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
