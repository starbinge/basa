import 'package:basa_app_project/features/decks/domain/entities/deck_entity.dart';
import 'package:basa_app_project/features/decks/domain/repositories/deck_repository.dart';
import 'package:bloc/bloc.dart';

import '../../../../../core/data/initial_database/initial_database.dart';
import 'deck_event.dart';
import 'deck_state.dart';

class DeckBloc extends Bloc<DeckEvent, DeckState> {
  final DeckRepository _repository;

  DeckBloc({required DeckRepository repository})
    : _repository = repository,
      super(
        DeckState(
          deckList: [],
          isLoading: false,
          isDeckExist: false,
          errorMessage: '',
        ),
      ) {
    on<FetchDecksList>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        final List<ImportedDeckData> rawDecksData = await _repository.getAll();
        final List<DeckEntity> finalDecksData = rawDecksData.map((deck) {
          return DeckEntity(
            id: deck.id,
            deckName: deck.deckName,
            activeHour: deck.activeHour,
            deckLanguage: deck.deckLanguage,
            extractedPath: deck.filePath,
            importedDate: deck.importedDate,
            deckColor: deck.colorDeck,
            dbPath: deck.dbPath,
            countryDeck: deck.countryDeck,
            language: deck.language,
            rolePlay: deck.rolePlay,
            difficulty: deck.difficulty,
            explanationRolePlay: deck.explanationRolePlay,
          );
        }).toList();
        emit(
          state.copyWith(
            deckList: finalDecksData,
            isLoading: false,
            isDeckExist: true,
            errorMessage: '',
          ),
        );
      } catch (e) {}
    });

    on<UpdateActiveHour>((event, emit) async {
      try {
        await _repository.updatingActiveHour(
          deckId: event.deckId,
          additionalHours: event.additionalHours,
        );
        add(FetchDecksList());
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });
  }
}
