import 'package:flutter/material.dart';

@immutable
sealed class DeckImportEvent {}

class SelectFile extends DeckImportEvent {}

class ImportDeck extends DeckImportEvent {
  final String deckFilePath;
  final String deckName;
  final String deckLanguage;
  final int deckColor;

  ImportDeck({
    required this.deckFilePath,
    required this.deckName,
    required this.deckLanguage,
    required this.deckColor,
  });
}
