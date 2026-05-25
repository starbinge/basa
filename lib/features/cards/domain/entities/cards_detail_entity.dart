import 'audio_entity.dart';

class CardsDetailEntity {
  final int cardsId;
  final String defaultLanguage;
  final String translatedLanguage;
  final AudioEntity audioPath;
  final int accuracyPercentage;
  final int activeRepetition;
  final String explanation;
  final String pronunciation;

  CardsDetailEntity({
    required this.defaultLanguage,
    required this.translatedLanguage,
    required this.audioPath,
    required this.accuracyPercentage,
    required this.activeRepetition,
    required this.cardsId,
    required this.explanation,
    required this.pronunciation,
  });
}
