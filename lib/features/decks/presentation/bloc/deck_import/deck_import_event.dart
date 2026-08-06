import 'package:flutter/material.dart';

@immutable
sealed class DeckImportEvent {}

class ImportDeck extends DeckImportEvent {
  final String deckName;
  final String deckFilePath;
  final String deckLanguage;
  final int deckColor;
  final String explanationRolePlay;

  ImportDeck({
    required this.deckName,
    required this.deckFilePath,
    required this.deckLanguage,
    required this.deckColor,
    this.explanationRolePlay = '',
  });
}
