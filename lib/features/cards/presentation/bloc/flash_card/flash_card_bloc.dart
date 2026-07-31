import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/domain/repositories/flash_card_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';

import '../../../../../core/errors/cards_error.dart';
import '../../../constants/enums/flashcard_answer_enum.dart';
import '../../../domain/entities/cards_detail_entity.dart';

part 'flash_card_event.dart';
part 'flash_card_state.dart';

class FlashCardBloc extends Bloc<FlashCardEvent, FlashCardState> {
  final FlashCardRepo _flashCardRepo;
  final CardsDao? _cardsDao;
  List<CardsDetailEntity> _allSortedCards = [];

  FlashCardBloc({required FlashCardRepo flashCardRepo, CardsDao? cardsDao})
    : _cardsDao = cardsDao,
      _flashCardRepo = flashCardRepo,
      super(FlashCardInitial()) {
    on<GenerateFlashCard>((data, emit) {
      emit(FlashCardIsLoading());
      try {
        if (_allSortedCards.isEmpty) {
          _allSortedCards = List<CardsDetailEntity>.from(data.listCard)
            ..sort((a, b) => a.queue.compareTo(b.queue));
        }

        int effectiveIndex = data.startIndex;
        if (effectiveIndex >= _allSortedCards.length) {
          effectiveIndex = 0;
        }

        final sliced = _allSortedCards.skip(effectiveIndex).take(10).toList();
        emit(FLashCardIsFinished(listCard: sliced));
      } catch (e) {
        emit(FLashCardIsError(errorMessage: e.toString()));
        throw FlashCardNotExist();
      }
    });
    on<AnsweringFlashCard>((card, emit) async {
      final CardsDetailEntity _selectedCard = card.selectedCard;
      final FlashcardAnswerEnum _answer = card.answer;
      final int _vR = _selectedCard.reps;
      final int _vF = _selectedCard.factor;
      final int _vL = _selectedCard.left;
      final int _vFl = _selectedCard.flags;
      final int _vT = card.timeMs;

      try {
        final int _newVf = _flashCardRepo.generateNewFactorValue(
          answer: _answer,
          vF: _vF,
          vT: _vT,
        );

        final int _newVd = _flashCardRepo.generateNewDueValue(
          answer: _answer,
          vF: _vF,
          vT: _vT,
        );

        final int _vQ = _flashCardRepo.generateQueueValue(
          answer: _answer,
          vF: _vF,
          vR: _vR,
          vT: _vT,
        );
        if (_cardsDao == null) throw CardDaoNotExist();
        await _cardsDao.updateCards(
          updatedCardValue: CardsTableCompanion(
            id: Value(_selectedCard.id),
            queue: Value(_vQ),
            odue: Value(_newVd),
            factor: Value(_newVf),
            left: Value(_vL - 1),
            reps: Value(_vR + 1),
            flags: Value(
              _answer == FlashcardAnswerEnum.correct ? _vFl + 1 : _vFl,
            ),
          ),
        );

        await _cardsDao.insertRevlog(
          RevlogTableCompanion(
            id: Value(DateTime.now().millisecondsSinceEpoch),
            cid: Value(_selectedCard.id),
            usn: const Value(-1),

            ease: Value(_answer == FlashcardAnswerEnum.correct ? 3 : 1),
            ivl: const Value(0),

            lastIvl: const Value(0),

            factor: Value(_newVf),
            time: Value(_vT),
            type: const Value(0),
          ),
        );
      } on CardDaoNotExist {
        emit(FLashCardIsError(errorMessage: "Card Dao Does Not Exist"));
      } catch (e) {
        emit(FLashCardIsError(errorMessage: e.toString()));
      }
    });
  }
}
