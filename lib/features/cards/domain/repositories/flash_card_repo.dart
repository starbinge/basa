import '../../constants/enums/flashcard_answer_enum.dart';

abstract class FlashCardRepo {
  int generateQueueValue({
    required FlashcardAnswerEnum answer,
    required int vF,
    required int vR,
  });

  int generateNewDueValue({
    required FlashcardAnswerEnum answer,
    required int vF,
  });

  int generateNewFactorValue({
    required FlashcardAnswerEnum answer,
    required int vF,
  });

  double generateFactorToRepsRatio({required int vF, required int vR});
}
