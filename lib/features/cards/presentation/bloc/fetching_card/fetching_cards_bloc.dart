import 'package:basa_app_project/features/cards/domain/repositories/card_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/cards_entity.dart';

part 'fetching_cards_event.dart';

part 'fetching_cards_state.dart';

class FetchingCardsBloc extends Bloc<FetchingCardsEvent, FetchingCardsState> {
  final CardRepo _cardRepo;

  FetchingCardsBloc({required CardRepo cardRepo})
    : _cardRepo = cardRepo,
      super(FetchingCardsInitial()) {
    on<FetchCards>((event, emit) async {
      emit(FetchingCardIsLoading());
      try {
        final result = await _cardRepo.fetchCards(deckId: event.deckId);
        emit(FetchingCardIsFinished(cardsEntity: result));
      } catch (e) {
        emit(FetchingCardIsError(errorMessage: e.toString()));
      }
    });
  }
}
