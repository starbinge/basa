import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/flash_card_repo.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';
import 'package:bloc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/errors/cards_error.dart';

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
    on<FlashCardEvent>((event, emit) {
      // TODO: implement event handler
    });
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
      final now = DateTime.now();
      final DateTime startOfWeek = now.subtract(
        Duration(days: now.weekday - 1),
      );
      final int _beginWeek = DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day,
      ).millisecondsSinceEpoch;
      final int _endWeek = _beginWeek + (7 * 24 * 60 * 60 * 1000);
      final int _todayTime = DateTime(
        now.year,
        now.month,
        now.day,
      ).millisecondsSinceEpoch;
      final int _tomorrowTime = DateTime(
        now.year,
        now.month,
        now.day + 1,
      ).millisecondsSinceEpoch;
      debugPrint("loading accuracy");
      emit(FlashCardIsLoading());
      try {
        if (_cardsDao == null) throw CardDaoNotExist();
        debugPrint("Fetching accuracy");

        final results = await Future.wait([
          _flashCardRepo.getThisMonthAccuracy(cardsDao: _cardsDao),
          _flashCardRepo.getPreviousMonthAccuracy(cardsDao: _cardsDao),
          _flashCardRepo.getMonthlyAccuracy(cardsDao: _cardsDao),
          _flashCardRepo.getWeeklyAccuracy(cardsDao: _cardsDao),
          _flashCardRepo.getDailyAccuracy(cardsDao: _cardsDao),
          _flashCardRepo.getAccuracyTopCards(
            cardsDao: _cardsDao,
            begin: getStartOfMonthEpoch(time: DateTime.now()),
            end: getStartOfNextMonthEpoch(time: DateTime.now()),
            orderBy: OrderEnums.desc,
          ),
          _flashCardRepo.getAccuracyTopCards(
            cardsDao: _cardsDao,
            begin: _beginWeek,
            end: _endWeek,
            orderBy: OrderEnums.desc,
          ),
          _flashCardRepo.getAccuracyTopCards(
            cardsDao: _cardsDao,
            begin: _todayTime,
            end: _tomorrowTime,
            orderBy: OrderEnums.desc,
          ),
          _flashCardRepo.getAccuracyTopCards(
            cardsDao: _cardsDao,
            begin: getStartOfMonthEpoch(time: DateTime.now()),
            end: getStartOfNextMonthEpoch(time: DateTime.now()),
            orderBy: OrderEnums.asc,
          ),
          _flashCardRepo.getAccuracyTopCards(
            cardsDao: _cardsDao,
            begin: _beginWeek,
            end: _endWeek,
            orderBy: OrderEnums.asc,
          ),
          _flashCardRepo.getAccuracyTopCards(
            cardsDao: _cardsDao,
            begin: _todayTime,
            end: _tomorrowTime,
            orderBy: OrderEnums.asc,
          ),
        ]);

        final _thisMonthAccuracy = results[0] as DeckAccuracy;
        final _previousMonthAccuracy = results[1] as DeckAccuracy;
        final _monthlyAccuracy = results[2] as List<DeckAccuracy>;
        final _weeklyAccuracy = results[3] as List<DeckAccuracy>;
        final _dailyAccuracy = results[4] as List<DeckAccuracy>;

        // Top 3 Most Accurate Cards
        final _monthlyTop3MostAccurate = results[5] as List<CardsDetailEntity>;
        final _weeklyTop3MostAccurate = results[6] as List<CardsDetailEntity>;
        final _todayTop3MostAccurate = results[7] as List<CardsDetailEntity>;

        // Top 3 Least Accurate Cards
        final _monthlyTop3LeastAccurate = results[8] as List<CardsDetailEntity>;
        final _weeklyTop3LeastAccurate = results[9] as List<CardsDetailEntity>;
        final _todayTop3LeastAccurate = results[10] as List<CardsDetailEntity>;

        emit(
          AccuracyStatsFinished(
            stats: DeckAccuracyStats(
              thisMonthDeckAccuracy: _thisMonthAccuracy,
              previousMonthDeckAccuracy: _previousMonthAccuracy,
              weeklyList: _weeklyAccuracy,
              monthlyList: _monthlyAccuracy,
              top3TodayMostAccurate: _todayTop3MostAccurate,
              top3TodayLeastAccurate: _todayTop3LeastAccurate,
              top3WeeklyMostAccurate: _weeklyTop3MostAccurate,
              top3WeeklyLeastAccurate: _weeklyTop3LeastAccurate,
              top3MonthlyMostAccurate: _monthlyTop3MostAccurate,
              top3MonthlyLeastAccurate: _monthlyTop3LeastAccurate,
              dailyAccuracyList: _dailyAccuracy,
            ),
          ),
        );
        debugPrint("Finished accuracy");
      } catch (e) {
        debugPrint("Error di GettingAccuracyStats: $e");
        emit(FLashCardIsError(errorMessage: e.toString()));
      }
    });
    on<GettingTimeConsumeStats>((stats, emit) async {
      final now = DateTime.now();
      final DateTime startOfWeek = now.subtract(
        Duration(days: now.weekday - 1),
      );
      final int _beginWeek = DateTime(
        startOfWeek.year,
        startOfWeek.month,
        startOfWeek.day,
      ).millisecondsSinceEpoch;
      final int _endWeek = _beginWeek + (7 * 24 * 60 * 60 * 1000);
      final int _todayTime = DateTime(
        now.year,
        now.month,
        now.day,
      ).millisecondsSinceEpoch;
      final int _tomorrowTime = DateTime(
        now.year,
        now.month,
        now.day + 1,
      ).millisecondsSinceEpoch;
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
          _flashCardRepo.getTopTimeConsumeCards(
            cardsDao: _cardsDao,
            begin: getStartOfMonthEpoch(time: DateTime.now()),
            end: getStartOfNextMonthEpoch(time: DateTime.now()),
            orderBy: OrderEnums.asc,
          ),
          _flashCardRepo.getTopTimeConsumeCards(
            cardsDao: _cardsDao,
            begin: _beginWeek,
            end: _endWeek,
            orderBy: OrderEnums.asc,
          ),
          _flashCardRepo.getTopTimeConsumeCards(
            cardsDao: _cardsDao,
            begin: _todayTime,
            end: _tomorrowTime,
            orderBy: OrderEnums.asc,
          ),

          _flashCardRepo.getTopTimeConsumeCards(
            cardsDao: _cardsDao,
            begin: getStartOfMonthEpoch(time: DateTime.now()),
            end: getStartOfNextMonthEpoch(time: DateTime.now()),
            orderBy: OrderEnums.desc,
          ),
          _flashCardRepo.getTopTimeConsumeCards(
            cardsDao: _cardsDao,
            begin: _beginWeek,
            end: _endWeek,
            orderBy: OrderEnums.desc,
          ),
          _flashCardRepo.getTopTimeConsumeCards(
            cardsDao: _cardsDao,
            begin: _todayTime,
            end: _tomorrowTime,
            orderBy: OrderEnums.desc,
          ),
        ]);

        final _thisMonthTimeConsume = results[0] as DeckTimeConsume;
        final _previousMonthTimeConsume = results[1] as DeckTimeConsume;
        final _monthlyTimeConsume = results[2] as List<DeckTimeConsume>;
        final _weeklyTimeConsume = results[3] as List<DeckTimeConsume>;
        final _dailyTimeConsume = results[4] as List<DeckTimeConsume>;

        // Top 3 Least Draining Time Cards
        final _monthlyLeast3TimeConsumeCards =
            results[5] as List<CardsDetailEntity>;
        final _weeklyLeast3TimeConsumeCards =
            results[6] as List<CardsDetailEntity>;
        final _todayLeast3TimeConsumeCards =
            results[7] as List<CardsDetailEntity>;

        // Top 3 Most Draining Time Cards

        final _monthlyTop3TimeConsumeCards =
            results[8] as List<CardsDetailEntity>;

        final _weeklyTop3TimeConsumeCards =
            results[9] as List<CardsDetailEntity>;

        final _todayTop3TimeConsumeCards =
            results[10] as List<CardsDetailEntity>;

        emit(
          TimeConsumeStatsFinished(
            thisMonth: _thisMonthTimeConsume,
            previousMonth: _previousMonthTimeConsume,
            monthlyAverage: _monthlyTimeConsume,
            weeklyAverage: _weeklyTimeConsume,
            dailyAverage: _dailyTimeConsume,
            top3TodayCards: _todayTop3TimeConsumeCards,
            top3MonthlyCards: _monthlyTop3TimeConsumeCards,
            top3WeeklyCards: _weeklyTop3TimeConsumeCards,
            top3LeastWeeklyCards: _weeklyLeast3TimeConsumeCards,
            top3LeastMonthlyCards: _monthlyLeast3TimeConsumeCards,
            top3LeastTodayCards: _todayLeast3TimeConsumeCards,
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
