import 'dart:math';

import 'package:basa_app_project/features/cards/constants/date_constanta.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/domain/repositories/flash_card_repo.dart';
import 'package:basa_app_project/features/cards/domain/usecases/calculate_delta_time.dart';

class FlashcardRepoImpl implements FlashCardRepo {
  @override
  int generateNewDueValue({
    required FlashcardAnswerEnum answer,
    required int vF,
  }) {
    int _vD;
    final DateTime _cD = getDateConstanta;
    final DateTime _now = DateTime.now();
    final int _deltaTime = calculateDeltaTime(startDate: _cD, endDate: _now);

    final int _newVf = generateNewFactorValue(answer: answer, vF: vF);

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
    required FlashcardAnswerEnum answer,
    required int vF,
  }) {
    int _result;
    switch (answer) {
      case FlashcardAnswerEnum.correct:
        _result = vF + 15;
        break;
      case FlashcardAnswerEnum.wrong:
        _result = vF - 20;
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
    required FlashcardAnswerEnum answer,
    required int vF,
    required int vR,
  }) {
    final DateTime _cD = getDateConstanta;

    double _ratio = generateFactorToRepsRatio(vF: vF, vR: vR);
    int _vD = generateNewDueValue(answer: answer, vF: vF);
    int _deltaTime = calculateDeltaTime(
      startDate: _cD,
      endDate: DateTime.now(),
    );

    double rawVq = (_vD - _deltaTime) * _ratio * pow(10, 2);

    int vQ = (rawVq * 100).round();

    return vQ;
  }
}
