import 'dart:math';

import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/core/errors/cards_error.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/quiz_game_enum.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/quiz_game_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/flash_card_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

part 'quiz_game_event.dart';
part 'quiz_game_state.dart';

class QuizGameBloc extends Bloc<QuizGameEvent, QuizGameState> {
  final CardsDao _cardsDao;
  final FlashCardRepo _flashCardRepo;
  QuizGameBloc({
    required CardsDao cardsDao,
    required FlashCardRepo flashCardRepo,
  }) : _flashCardRepo = flashCardRepo,
       _cardsDao = cardsDao,
       super(QuizGameInitial()) {
    on<QuizGameEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GeneratingQuizGameQuestions>((data, emit) {
      final List<CardsDetailEntity> sortedCard = List.from(data.listCards);
      sortedCard.sort((a, b) {
        return a.queue.compareTo(b.queue);
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

          QuizGameEnum questionType;
          String question = "";
          String correctAnswer = "";

          if (index % 3 == 0) {
            questionType = QuizGameEnum.translateLanguage;
            question = data.defaultLanguage;
            correctAnswer = data.translatedLanguage;
          } else if (index % 3 == 1) {
            questionType = QuizGameEnum.translateLanguage;
            question = data.translatedLanguage;
            correctAnswer = data.defaultLanguage;
          } else if (data.audioPath.isNotEmpty) {
            questionType = QuizGameEnum.audio;
            question = data.audioPath.first;
            correctAnswer = data.defaultLanguage;
          } else {
            questionType = QuizGameEnum.translateLanguage;
            question = data.defaultLanguage;
            correctAnswer = data.translatedLanguage;
          }

          Set<String> wrongOptions = {};

          while (wrongOptions.length < 3) {
            final randomCard = limitCard[Random().nextInt(limitCard.length)];

            String randomOption = (correctAnswer == data.defaultLanguage)
                ? randomCard.defaultLanguage
                : randomCard.translatedLanguage;

            if (randomOption != correctAnswer) {
              wrongOptions.add(randomOption);
            }
          }

          List<String> answerOptions = wrongOptions.toList();
          answerOptions.add(correctAnswer);
          answerOptions.shuffle();

          return QuizGameEntity(
            questionType: questionType,
            question: question,
            correctAnswer: correctAnswer,
            options: answerOptions,
            cid: data.id,
          );
        }).toList();

        emit(QuizGameIsFinish(cards: cards));
      } catch (e) {
        debugPrint(e.toString());
        emit(QuizGameIsError(errorMessage: e.toString()));
      }
    });
    on<AnsweringQuestion>((data, emit) async {
      // Value of selected Card
      final CardsDetailEntity _selectedCard = data.selectedCard;
      //Value of Flash Card Answer
      final FlashcardAnswerEnum _answer = data.answer;
      //vR = Value of Card Repetition
      final int _vR = _selectedCard.reps;
      //vF = Value of Card Factor
      final int _vF = _selectedCard.factor;
      //vD = Value of Card Left
      final int _vL = _selectedCard.left;
      //vFl = Value of Card Flags
      final int _vFl = _selectedCard.flags;
      //vT = Value of time spent on this data
      final int _vT = data.timeMs;

      try {
        //Calculating New Factor Value
        final int _newVf = _flashCardRepo.generateNewFactorValue(
          answer: _answer,
          vF: _vF,
          vT: _vT,
        );

        //Calculating New Due Value
        final int _newVd = _flashCardRepo.generateNewDueValue(
          answer: _answer,
          vF: _vF,
          vT: _vT,
        );

        //Calculating New Que Value
        final int _vQ = _flashCardRepo.generateQueueValue(
          answer: _answer,
          vF: _vF,
          vR: _vR,
          vT: _vT,
        );
        debugPrint("Generating Queue Done");
        debugPrint('Nilai vQ: $_vQ');
        // Updating Cards
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
            usn: Value(-1),

            ease: Value(_answer == FlashcardAnswerEnum.correct ? 3 : 1),
            ivl: Value(0),

            lastIvl: Value(0),

            factor: Value(_newVf),
            time: Value(_vT),
            type: Value(0),
          ),
        );
      } on CardDaoNotExist {
        emit(QuizGameIsError(errorMessage: "Card Dao Does Not Exist"));
      } catch (e) {
        debugPrint('AnsweringFlashCard error: $e');
        emit(QuizGameIsError(errorMessage: e.toString()));
      }
    });
  }
}
