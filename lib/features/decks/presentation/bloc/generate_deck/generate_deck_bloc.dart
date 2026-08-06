import 'package:basa_app_project/core/errors/input_errors.dart';
import 'package:basa_app_project/features/decks/domain/repositories/deck_repository.dart';
import 'package:basa_app_project/features/decks/domain/repositories/generate_deck_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'generate_deck_event.dart';
part 'generate_deck_state.dart';

class GenerateDeckBloc extends Bloc<GenerateDeckEvent, GenerateDeckState> {
  final GenerateDeckRepo _generateDeckRepo;
  final DeckRepository _deckRepository;

  GenerateDeckBloc({
    required GenerateDeckRepo generateDeckRepo,
    required DeckRepository deckRepository,
  }) : _generateDeckRepo = generateDeckRepo,
       _deckRepository = deckRepository,
       super(GenerateDeckInitial()) {
    on<GenerateDeck>((data, emit) async {
      emit(GenerateDeckLoading());
      try {
        final Map<String, dynamic> jsonData = await _generateDeckRepo
            .generateDeck(
              requestData: {
                'defaultLanguage': data.defaultLanguage,
                'rolePlay': data.rolePlay,
                'targetLang': data.targetLang,
                'difficulty': data.difficulty,
              },
            );
        await _deckRepository.generateDeck(
          jsonData: jsonData,
          deckName: data.deckName,
          colorDeck: data.colorDeck,
          countryDeck: data.countryDeck,
        );
        emit(GenerateDeckIsFinished());
      } on DeckAlreadyExistsException {
        emit(GenerateDeckIsExist());
      } catch (e) {
        emit(GenerateDeckIsError(errorMessage: e.toString()));
      }
    });
  }
}
