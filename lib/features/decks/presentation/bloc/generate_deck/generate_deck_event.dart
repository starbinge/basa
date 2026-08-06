part of 'generate_deck_bloc.dart';

@immutable
sealed class GenerateDeckEvent {}

final class GenerateDeck extends GenerateDeckEvent {
  final String deckName;
  final int colorDeck;
  final String countryDeck;
  final String defaultLanguage;
  final String rolePlay;
  final String targetLang;
  final String difficulty;

  GenerateDeck({
    required this.deckName,
    required this.colorDeck,
    required this.countryDeck,
    required this.defaultLanguage,
    required this.rolePlay,
    required this.targetLang,
    required this.difficulty,
  });
}
