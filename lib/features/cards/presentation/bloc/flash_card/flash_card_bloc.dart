import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/data/models/fetching_cards_model.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/flash_card_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';

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
      //vFl = Value of Card Flags
      final int _vFl = _selectedCard.flags;
      //vT = Value of time spent on this card
      final int _vT = card.timeMs;

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
        if (_cardsDao == null) throw CardDaoNotExist();
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
        emit(FLashCardIsError(errorMessage: "Card Dao Does Not Exist"));
      } catch (e) {
        debugPrint('AnsweringFlashCard error: $e');
        emit(FLashCardIsError(errorMessage: e.toString()));
      }
    });
    on<GettingAccuracyStats>((stats, emit) async {
      debugPrint("loading");
      emit(FlashCardIsLoading());
      try {
        if (_cardsDao == null) throw CardDaoNotExist();
        debugPrint("Fetching");

        // 🔥 Jalankan semua query secara paralel sekaligus!
        final results = await Future.wait([
          _flashCardRepo.getThisMonthAccuracy(cardsDao: _cardsDao),
          _flashCardRepo.getPreviousMonthAccuracy(cardsDao: _cardsDao),
          _flashCardRepo.getMonthlyAccuracy(cardsDao: _cardsDao),
          _flashCardRepo.getWeeklyAccuracy(cardsDao: _cardsDao),
          _flashCardRepo.getTop3MostAccurateCards(cardsDao: _cardsDao),
          _flashCardRepo.getTop3LeastAccurateCards(cardsDao: _cardsDao),
        ]);

        // Ambil hasil sesuai urutan indeksnya
        final _thisMonthAccuracy = results[0] as DeckAccuracy;
        final _previousMonthAccuracy = results[1] as DeckAccuracy;
        final _monthlyAccuracy = results[2] as List<DeckAccuracy>;
        final _weeklyAccuracy = results[3] as List<DeckAccuracy>;
        final _top3MostAccurateCards = results[4] as List<CardsDetailEntity>;
        final _top3LeastAccurateCards = results[5] as List<CardsDetailEntity>;
        debugPrint(_top3LeastAccurateCards.length.toString());
        emit(
          AccuracyStatsFinished(
            stats: DeckAccuracyStats(
              thisMonthDeckAccuracy: _thisMonthAccuracy,
              previousMonthDeckAccuracy: _previousMonthAccuracy,
              weeklyList: _weeklyAccuracy,
              monthlyList: _monthlyAccuracy,
              top3MostAccurate: _top3MostAccurateCards,
              top3LeastAccurate: _top3LeastAccurateCards,
            ),
          ),
        );
        debugPrint("Finished");
      } catch (e) {
        debugPrint("Error di GettingAccuracyStats: $e");
        emit(FLashCardIsError(errorMessage: e.toString()));
      }
    });
    on<GettingTimeConsumeStats>((stats, emit) async {
      debugPrint("loading time consume");
      emit(FlashCardIsLoading());
      try {
        if (_cardsDao == null) throw CardDaoNotExist();
        debugPrint("Fetching time consume");

        final results = await Future.wait([
          _flashCardRepo.getThisMonthTimeConsume(cardsDao: _cardsDao),
          _flashCardRepo.getPreviousMonthTimeConsume(cardsDao: _cardsDao),
          _flashCardRepo.getMonthlyTimeConsume(cardsDao: _cardsDao),
          _flashCardRepo.getWeeklyTimeConsume(cardsDao: _cardsDao),
          _flashCardRepo.getDailyTimeConsume(cardsDao: _cardsDao),
        ]);

        final _thisMonthTimeConsume = results[0] as DeckTimeConsume;
        final _previousMonthTimeConsume = results[1] as DeckTimeConsume;
        final _monthlyTimeConsume = results[2] as List<DeckTimeConsume>;
        final _weeklyTimeConsume = results[3] as List<DeckTimeConsume>;
        final _dailyTimeConsume = results[4] as List<DeckTimeConsume>;
        emit(
          TimeConsumeStatsFinished(
            thisMonth: _thisMonthTimeConsume,
            previousMonth: _previousMonthTimeConsume,
            monthlyAverage: _monthlyTimeConsume,
            weeklyAverage: _weeklyTimeConsume,
            dailyAverage: _dailyTimeConsume,
          ),
        );
        debugPrint("Finished time consume");
      } catch (e) {
        debugPrint("Error di GettingTimeConsumeStats: $e");
        emit(FLashCardIsError(errorMessage: e.toString()));
      }
    });
  }
}
