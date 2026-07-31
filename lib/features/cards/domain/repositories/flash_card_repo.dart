import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';

abstract class FlashCardRepo {
  int generateQueueValue({
    required int vT,
    required FlashcardAnswerEnum answer,
    required int vF,
    required int vR,
  });

  int generateNewDueValue({
    required FlashcardAnswerEnum answer,
    required int vF,
    required int vT,
  });

  int generateNewFactorValue({
    required int vT,
    required FlashcardAnswerEnum answer,
    required int vF,
  });

  double generateFactorToRepsRatio({required int vF, required int vR});
}
