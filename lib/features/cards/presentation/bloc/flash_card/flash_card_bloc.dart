import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/data/models/fetching_cards_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/errors/cards_error.dart';

part 'flash_card_event.dart';

part 'flash_card_state.dart';

class FlashCardBloc extends Bloc<FlashCardEvent, FlashCardState> {
  FlashCardBloc() : super(FlashCardInitial()) {
    on<FlashCardEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GenerateFlashCard>((data, emit) {
      emit(FlashCardIsLoading());
      try {
        final _cardList = List<CardsDetailEntity>.from(data.listCard);

        _cardList.sort((a, b) => a.queue.compareTo(b.queue));

        final topTenCards = _cardList.take(10).toList();
        emit(FLashCardIsFinished(listCard: topTenCards));
      } catch (e) {
        emit(FLashCardIsError(errorMessage: e.toString()));
        throw FlashCardNotExist();
      }
    });
    on<AnsweringFlashCard>((card, emit) {
      //vQ = Value of Card Queue
      int _vQ;
      // Value of selected Card
      final CardsDetailEntity _selectedCard = card.selectedCard;

      //Value of Flash Card Answer
      final FlashcardAnswerEnum _answer = card.answer;

      //vD = Value of Card Due
      final int _vD = _selectedCard.odue;
      //vR = Value of Card Repetition
      final int _vR = _selectedCard.reps;
      //vF = Value of Card Factor
      final int _vF = _selectedCard.factor;
      //vD = Value of Card Left
      final int _vL = _selectedCard.left;

      
    });
  }
}
