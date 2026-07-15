import 'dart:math';

import 'package:basa_app_project/features/cards/constants/date_constanta.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/data/models/fetching_cards_model.dart';
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
        monthName: data.monthName,
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
        DeckAccuracy(monthName: "Month is Empty", accuracyNumber: 0);
  }

  @override
  Future<DeckAccuracy> getThisMonthAccuracy({
    required CardsDao cardsDao,
  }) async {
    final DeckAccuracy? _thisMonthAccuracy = await cardsDao
        .getThisMonthAccuracy();
    return _thisMonthAccuracy ??
        DeckAccuracy(monthName: "Month is Empty", accuracyNumber: 0);
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
        monthName: data.monthName,
        accuracyNumber: data.accuracyNumber,
      );
    }).toList();
  }

  @override
  Future<List<CardsDetailEntity>> getTop3MostAccurateCards({
    required CardsDao cardsDao,
  }) async {
    final List<CardsDetailEntity>? _top3MostAccucarateCards = await cardsDao
        .getTop3MostAccurateCards();
    if (_top3MostAccucarateCards == null || _top3MostAccucarateCards.isEmpty) {
      return [];
    }
    return _top3MostAccucarateCards.map((card) {
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
  Future<List<CardsDetailEntity>> getTop3LeastAccurateCards({
    required CardsDao cardsDao,
  }) async {
    final List<CardsDetailEntity>? _top3LeastCards = await cardsDao
        .getTop3LeastAccurateCards();
    if (_top3LeastCards == null || _top3LeastCards.isEmpty) {
      return [];
    }
    return _top3LeastCards.map((card) {
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
}
