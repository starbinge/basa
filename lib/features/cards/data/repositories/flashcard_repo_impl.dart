import 'dart:math';

import 'package:basa_app_project/features/cards/constants/date_constanta.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/flash_card_repo.dart';
import 'package:basa_app_project/features/cards/domain/usecases/calculate_delta_time.dart';
import 'package:flutter/material.dart';

class FlashcardRepoImpl implements FlashCardRepo {
  @override
  int generateNewDueValue({
    required FlashcardAnswerEnum answer,
    required int vF,
    required int vT,
  }) {
    int _vD;
    final DateTime _cD = getDateConstanta;
    final DateTime _now = DateTime.now();
    final int _deltaTime = calculateDeltaTime(startDate: _cD, endDate: _now);

    final int _newVf = generateNewFactorValue(answer: answer, vF: vF, vT: vT);

    switch (answer) {
      case FlashcardAnswerEnum.correct:
        _vD = _deltaTime + ((3 * _newVf) / 100).round();
        break;
      case FlashcardAnswerEnum.wrong:
        _vD = _deltaTime + ((1.5 * _newVf) / 100).round();
        break;
    }

    return _vD;
  }

  @override
  int generateNewFactorValue({
    required int vT,
    required FlashcardAnswerEnum answer,
    required int vF,
  }) {
    int _result;
    switch (answer) {
      case FlashcardAnswerEnum.correct:
        if (vT <= 3000) {
          _result = vF + 15;
        } else if (vT <= 7000) {
          _result = vF + 10;
        } else {
          _result = vF + 1;
        }
        break;
      case FlashcardAnswerEnum.wrong:
        if (vT <= 7000) {
          _result = vF - 20;
        } else {
          _result = vF - 30;
        }
        break;
    }

    return _result < 130 ? 130 : _result;
  }

  @override
  double generateFactorToRepsRatio({required int vF, required int vR}) {
    return (vF / 100) / (vR + 1);
  }

  @override
  int generateQueueValue({
    required int vT,
    required FlashcardAnswerEnum answer,
    required int vF,
    required int vR,
  }) {
    final DateTime _cD = getDateConstanta;

    double _ratio = generateFactorToRepsRatio(vF: vF, vR: vR);
    int _vD = generateNewDueValue(answer: answer, vF: vF, vT: vT);
    int _deltaTime = calculateDeltaTime(
      startDate: _cD,
      endDate: DateTime.now(),
    );

    double rawVq = (_vD - _deltaTime) * _ratio * pow(10, 2);

    int vQ = (rawVq * 100).round();

    return vQ;
  }

  @override
  Future<List<DeckAccuracy>> getMonthlyAccuracy({
    required CardsDao cardsDao,
  }) async {
    final List<DeckAccuracy>? _monthlyAccuracy = await cardsDao
        .getMonthlyAccuracy();
    if (_monthlyAccuracy == null || _monthlyAccuracy.isEmpty) {
      return [];
    }
    return _monthlyAccuracy.map((data) {
      return DeckAccuracy(
        timeName: data.timeName,
        accuracyNumber: data.accuracyNumber,
      );
    }).toList();
  }

  @override
  Future<List<DeckAccuracy>> getDailyAccuracy({
    required CardsDao cardsDao,
  }) async {
    final List<DeckAccuracy>? _dailyAccuracy = await cardsDao
        .getDailyAccuracyList();
    if (_dailyAccuracy == null || _dailyAccuracy.isEmpty) {
      return [];
    }
    return _dailyAccuracy.map((data) {
      return DeckAccuracy(
        timeName: data.timeName,
        accuracyNumber: data.accuracyNumber,
      );
    }).toList();
  }

  @override
  Future<DeckAccuracy> getPreviousMonthAccuracy({
    required CardsDao cardsDao,
  }) async {
    final DeckAccuracy? _previousMonthAccuracy = await cardsDao
        .getPreviousMonthAccuracy();
    return _previousMonthAccuracy ??
        DeckAccuracy(timeName: "Month is Empty", accuracyNumber: 0);
  }

  @override
  Future<DeckAccuracy> getThisMonthAccuracy({
    required CardsDao cardsDao,
  }) async {
    final DeckAccuracy? _thisMonthAccuracy = await cardsDao
        .getThisMonthAccuracy();
    return _thisMonthAccuracy ??
        DeckAccuracy(timeName: "Month is Empty", accuracyNumber: 0);
  }

  @override
  Future<List<DeckAccuracy>> getWeeklyAccuracy({
    required CardsDao cardsDao,
  }) async {
    debugPrint("Still running");
    final List<DeckAccuracy>? _weeklyAccuracy = await cardsDao
        .getWeeklyAccuracy();
    if (_weeklyAccuracy == null || _weeklyAccuracy.isEmpty) {
      return [];
    }
    return _weeklyAccuracy.map((data) {
      return DeckAccuracy(
        timeName: data.timeName,
        accuracyNumber: data.accuracyNumber,
      );
    }).toList();
  }

  @override
  Future<List<CardsDetailEntity>> getAccuracyTopCards({
    required CardsDao cardsDao,
    required int begin,
    required int end,
    required OrderEnums orderBy,
  }) async {
    final List<CardsDetailEntity>? _topCards = await cardsDao
        .getAccuracyTopCards(
          begin: begin,
          end: end,
          orderBy: orderBy,
          limit: 3,
        );
    if (_topCards == null || _topCards.isEmpty) {
      return [];
    }
    return _topCards.map((card) {
      return CardsDetailEntity(
        id: card.id,
        noteId: card.noteId,
        queue: card.queue,
        reps: card.reps,
        odue: card.odue,
        ivl: card.ivl,
        factor: card.factor,
        defaultLanguage: card.defaultLanguage,
        translatedLanguage: card.translatedLanguage,
        audioPath: card.audioPath,
        descriptions: card.descriptions,
        left: card.left,
        flags: card.flags,
      );
    }).toList();
  }

  @override
  Future<DeckTimeConsume> getThisMonthTimeConsume({
    required CardsDao cardsDao,
  }) async {
    final DeckTimeConsume? _thisMonth = await cardsDao
        .getThisMonthTimeConsume();
    return _thisMonth ??
        DeckTimeConsume(timeName: "Month is Empty", avgTime: 0, totalTime: 0);
  }

  @override
  Future<DeckTimeConsume> getPreviousMonthTimeConsume({
    required CardsDao cardsDao,
  }) async {
    final DeckTimeConsume? _previousMonth = await cardsDao
        .getPreviousMonthTimeConsume();
    return _previousMonth ??
        DeckTimeConsume(timeName: "Month is Empty", avgTime: 0, totalTime: 0);
  }

  @override
  Future<List<DeckTimeConsume>> getMonthlyTimeConsume({
    required CardsDao cardsDao,
  }) async {
    final List<DeckTimeConsume>? _monthly = await cardsDao
        .getMonthlyTimeConsumeList();
    if (_monthly == null || _monthly.isEmpty) {
      return [];
    }
    return _monthly.map((data) {
      return DeckTimeConsume(
        timeName: data.timeName,
        avgTime: data.avgTime,
        totalTime: data.totalTime,
      );
    }).toList();
  }

  @override
  Future<List<DeckTimeConsume>> getWeeklyTimeConsume({
    required CardsDao cardsDao,
  }) async {
    final List<DeckTimeConsume>? _weekly = await cardsDao
        .getWeeklyTimeConsumeList();
    if (_weekly == null || _weekly.isEmpty) {
      return [];
    }
    return _weekly.map((data) {
      return DeckTimeConsume(
        timeName: data.timeName,
        avgTime: data.avgTime,
        totalTime: data.totalTime,
      );
    }).toList();
  }

  @override
  Future<List<DeckTimeConsume>> getDailyTimeConsume({
    required CardsDao cardsDao,
  }) async {
    final List<DeckTimeConsume>? _daily = await cardsDao
        .getDailyTimeConsumeList();
    if (_daily == null || _daily.isEmpty) {
      return [];
    }
    return _daily.map((data) {
      return DeckTimeConsume(
        timeName: data.timeName,
        avgTime: data.avgTime,
        totalTime: data.totalTime,
      );
    }).toList();
  }

  @override
  Future<List<CardsDetailEntity>> getTopTimeConsumeCards({
    required CardsDao cardsDao,
    required int begin,
    required int end,
    required OrderEnums orderBy,
  }) async {
    final List<CardsDetailEntity>? _listCards = await cardsDao
        .getTimeConsumeTopCards(
          begin: begin,
          end: end,
          orderBy: orderBy,
          limit: 3,
        );
    if (_listCards == null || _listCards.isEmpty) {
      return [
        CardsDetailEntity(
          id: 0,
          noteId: 0,
          queue: 0,
          reps: 0,
          odue: 0,
          ivl: 0,
          defaultLanguage: "",
          translatedLanguage: "",
          descriptions: [""],
          audioPath: [""],
          factor: 0,
          left: 0,
          flags: 0,
        ),
      ];
    }
    return _listCards;
  }

  @override
  Future<List<CardsDetailEntity>> getHistoryCards({
    required CardsDao cardsDao,
    required int begin,
    required int end,
    required OrderEnums orderBy,
  }) async {
    final List<CardsDetailEntity>? _listCards = await cardsDao
        .getTimeConsumeTopCards(
          begin: begin,
          end: end,
          orderBy: orderBy,
          limit: 10,
        );
    if (_listCards == null || _listCards.isEmpty) {
      return [
        CardsDetailEntity(
          id: 0,
          noteId: 0,
          queue: 0,
          reps: 0,
          odue: 0,
          ivl: 0,
          defaultLanguage: "",
          translatedLanguage: "",
          descriptions: [""],
          audioPath: [""],
          factor: 0,
          left: 0,
          flags: 0,
        ),
      ];
    }
    return _listCards;
  }
}
