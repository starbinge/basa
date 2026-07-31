import 'package:flutter/material.dart';

@immutable
sealed class FetchingDeckEvent {}

class FetchDecksList extends FetchingDeckEvent {}

class UpdateActiveHour extends FetchingDeckEvent {
  final int deckId;
  final int additionalHours;

  UpdateActiveHour({
    required this.deckId,
    required this.additionalHours,
  });
}
