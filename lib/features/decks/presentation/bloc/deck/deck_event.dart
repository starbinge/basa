import 'package:flutter/material.dart';

@immutable
sealed class DeckEvent {}

class FetchDecksList extends DeckEvent {}

class UpdateActiveHour extends DeckEvent {
  final int deckId;
  final int additionalHours;

  UpdateActiveHour({
    required this.deckId,
    required this.additionalHours,
  });
}
