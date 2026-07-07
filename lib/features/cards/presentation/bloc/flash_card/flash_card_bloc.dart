import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/data/models/fetching_cards_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/flash_card_repo.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../../core/errors/cards_error.dart';

part 'flash_card_event.dart';

part 'flash_card_state.dart';

class FlashCardBloc extends Bloc<FlashCardEvent, FlashCardState> {
  final FlashCardRepo _flashCardRepo;
  final CardsDao? _cardsDao;

  FlashCardBloc({required FlashCardRepo flashCardRepo, CardsDao? cardsDao})
    : _cardsDao = cardsDao,
      _flashCardRepo = flashCardRepo,
      super(FlashCardInitial()) {
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
    on<AnsweringFlashCard>((card, emit) async {
      // Value of selected Card
      final CardsDetailEntity _selectedCard = card.selectedCard;
      //Value of Flash Card Answer
      final FlashcardAnswerEnum _answer = card.answer;
      //vR = Value of Card Repetition
      final int _vR = _selectedCard.reps;
      //vF = Value of Card Factor
      final int _vF = _selectedCard.factor;
      //vD = Value of Card Left
      final int _vL = _selectedCard.left;

      try {
        //Calculating New Factor Value
        final int _newVf = _flashCardRepo.generateNewFactorValue(
          answer: _answer,
          vF: _vF,
        );

        //Calculating New Due Value
        final int _newVd = _flashCardRepo.generateNewDueValue(
          answer: _answer,
          vF: _vF,
        );

        //Calculating New Que Value
        final int _vQ = _flashCardRepo.generateQueueValue(
          answer: _answer,
          vF: _vF,
          vR: _vR,
        );
        if (_cardsDao == null) throw CardDaoNotExist();

        // Updating Cards
        await _cardsDao.updateCards(
          updatedCardValue: CardsTableCompanion(
            id: Value(_selectedCard.id),
            queue: Value(_vQ),
            odue: Value(_newVd),
            factor: Value(_newVf),
            left: Value(_vL - 1),
            reps: Value(_vR + 1),
          ),
        );
      } on CardDaoNotExist {
        emit(FLashCardIsError(errorMessage: "Card Dao Does Not Exist"));
      } catch (e, stackTrace) {
        debugPrint('Stack trace: $stackTrace');
        emit(FLashCardIsError(errorMessage: e.toString()));
      }
    });
  }
}
