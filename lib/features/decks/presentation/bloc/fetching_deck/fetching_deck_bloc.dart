import 'package:basa_app_project/core/database/initial_database/initial_database.dart';
import 'package:basa_app_project/features/decks/domain/entities/deck_entity.dart';
import 'package:basa_app_project/features/decks/domain/repositories/deck_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'fetching_deck_event.dart';
import 'fetching_deck_state.dart';

class FetchingDeckBloc extends Bloc<FetchingDeckEvent, FetchingDeckState> {
  final DeckRepository _repository;

  FetchingDeckBloc({required DeckRepository repository})
    : _repository = repository,
      super(FetchingDeckState(deckList: [])) {
    on<FetchDecksList>((event, emit) async {
      debugPrint("Fetch");
      try {
        final List<ImportedDeckData> rawDecksData = await _repository.getAll();
        final List<DeckEntity> finalDecksData = rawDecksData.map((deck) {
          return DeckEntity(
            id: deck.id,
            deckName: deck.deckName,
            activeHour: deck.activeHour,
            apkgPath: deck.apkgPath,
            deckLanguage: deck.deckLanguage,
            extractedPath: deck.extractedPath,
            importedDate: deck.importedDate,
            deckColor: deck.colorDeck,
          );
        }).toList();
        emit(FetchingDeckState(deckList: finalDecksData));
      } catch (e) {}
    });
  }
}
