import 'package:basa_app_project/features/decks/domain/entities/deck_entity.dart';
import 'package:flutter/material.dart';

@immutable
class DeckState {
  final List<DeckEntity> deckList;
  final bool isLoading;
  final bool isDeckExist;
  final String errorMessage;

  DeckState({
    required this.deckList,
    required this.isLoading,
    required this.isDeckExist,
    required this.errorMessage,
  });

  DeckState copyWith({
    List<DeckEntity>? deckList,
    bool? isLoading,
    bool? isDeckExist,
    String? errorMessage,
  }) {
    return DeckState(
      deckList: deckList ?? this.deckList,
      isLoading: isLoading ?? this.isLoading,
      isDeckExist: isDeckExist ?? this.isDeckExist,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
