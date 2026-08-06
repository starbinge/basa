import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:bloc/bloc.dart';

import '../../../../../core/errors/cards_error.dart';
import '../../../constants/enums/flashcard_answer_enum.dart';
import '../../../domain/entities/cards_detail_entity.dart';

part 'flash_card_event.dart';
part 'flash_card_state.dart';

class FlashCardBloc extends Bloc<FlashCardEvent, FlashCardState> {
  final GeneratedDeckDao _generatedDeckDao;
  List<CardsDetailEntity> _allSortedCards = [];

  FlashCardBloc({required GeneratedDeckDao generatedDeckDao})
    : _generatedDeckDao = generatedDeckDao,
      super(FlashCardInitial()) {
    on<GenerateFlashCard>((data, emit) {
      emit(FlashCardIsLoading());
      try {
        if (_allSortedCards.isEmpty) {
          _allSortedCards = List<CardsDetailEntity>.from(data.listCard)
            ..sort((a, b) => a.id.compareTo(b.id));
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
      final int _vT = card.timeMs;

      try {
        await _generatedDeckDao.updateScore(
          cardId: _selectedCard.id,
          isCorrect: _answer == FlashcardAnswerEnum.correct,
        );

        await _generatedDeckDao.insertHistory(
          idC: _selectedCard.id,
          isCorrect: _answer == FlashcardAnswerEnum.correct,
          totalTime: _vT,
        );
      } catch (e) {
        emit(FLashCardIsError(errorMessage: e.toString()));
      }
    });
  }
}
