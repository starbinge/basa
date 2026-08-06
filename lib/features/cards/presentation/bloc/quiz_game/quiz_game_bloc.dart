import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/quiz_game_enum.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/quiz_game_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'quiz_game_event.dart';
part 'quiz_game_state.dart';

class QuizGameBloc extends Bloc<QuizGameEvent, QuizGameState> {
  final GeneratedDeckDao _generatedDeckDao;

  QuizGameBloc({required GeneratedDeckDao generatedDeckDao})
    : _generatedDeckDao = generatedDeckDao,
      super(QuizGameInitial()) {
    on<GeneratingQuizGameQuestions>((data, emit) {
      final List<CardsDetailEntity> sortedCard = List.from(data.listCards);
      sortedCard.sort((a, b) {
        return a.id.compareTo(b.id);
      });

      int effectiveIndex = data.startIndex;
      if (effectiveIndex >= sortedCard.length) {
        effectiveIndex = 0;
      }

      final limitCard = sortedCard.skip(effectiveIndex).take(10).toList();

      emit(QuizGameIsLoading());

      try {
        final List<QuizGameEntity> cards = limitCard.asMap().entries.map((
          entry,
        ) {
          final int index = entry.key;
          final CardsDetailEntity data = entry.value;

          String question = "";
          String correctAnswer = "";

          if (index % 3 == 0) {
            question = data.defaultLanguage;
            correctAnswer = data.translatedLanguage;
          } else {
            question = data.translatedLanguage;
            correctAnswer = data.defaultLanguage;
          }

          final List<String> wrongOptions = limitCard
              .map((randomCard) {
                return (correctAnswer == data.defaultLanguage)
                    ? randomCard.defaultLanguage
                    : randomCard.translatedLanguage;
              })
              .where((option) => option.isNotEmpty && option != correctAnswer)
              .toSet()
              .toList()
            ..shuffle();

          final List<String> answerOptions =
              wrongOptions.take(3).toList()..add(correctAnswer);
          answerOptions.shuffle();

          return QuizGameEntity(
            questionType: QuizGameEnum.translateLanguage,
            question: question,
            correctAnswer: correctAnswer,
            options: answerOptions,
            cid: data.id,
          );
        }).toList();

        emit(QuizGameIsFinish(cards: cards));
      } catch (e) {
        emit(QuizGameIsError(errorMessage: e.toString()));
      }
    });
    on<AnsweringQuestion>((data, emit) async {
      final CardsDetailEntity _selectedCard = data.selectedCard;
      final FlashcardAnswerEnum _answer = data.answer;
      final int _vT = data.timeMs;

      try {
        await _generatedDeckDao.updateScore(
          cardId: _selectedCard.id,
          isCorrect: data.isCorrect,
        );

        await _generatedDeckDao.insertHistory(
          idC: _selectedCard.id,
          isCorrect: _answer == FlashcardAnswerEnum.correct,
          totalTime: _vT,
        );

        final currentState = state as QuizGameIsFinish;
        emit(
          currentState.copyWith(
            totalQuestion: currentState.cards.length,
            activeQuestion: (currentState.activeQuestion ?? 0) + 1,
            answeredQuestion: data.isCorrect
                ? (currentState.answeredQuestion ?? 0) + 1
                : (currentState.answeredQuestion ?? 0),
          ),
        );
      } catch (e) {
        emit(QuizGameIsError(errorMessage: e.toString()));
      }
    });
  }
}
