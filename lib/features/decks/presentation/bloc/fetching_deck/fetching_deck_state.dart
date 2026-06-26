import 'package:basa_app_project/features/decks/domain/entities/deck_entity.dart';
import 'package:flutter/material.dart';

@immutable
class FetchingDeckState {
  final List<DeckEntity> deckList;
  final bool isLoading;
  final bool isDeckExist;
  final String errorMessage;

  FetchingDeckState({
    required this.deckList,
    required this.isLoading,
    required this.isDeckExist,
  required this.errorMessage,
  });

  FetchingDeckState copyWith({
    List<DeckEntity>? deckList,
    bool? isLoading,
    bool? isDeckExist,
    String? errorMessage,
  }) {
    return FetchingDeckState(
      deckList: deckList ?? this.deckList,
      isLoading: isLoading ?? this.isLoading,
      isDeckExist: isDeckExist ?? this.isDeckExist,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
