import 'package:basa_app_project/features/decks/domain/entities/deck_entity.dart';
import 'package:flutter/material.dart';

@immutable
class FetchingDeckState {
  final List<DeckEntity> deckList;

  const FetchingDeckState({required this.deckList});
}
