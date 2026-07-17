import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/data/models/fetching_cards_model.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';

import '../../constants/enums/flashcard_answer_enum.dart';

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

  Future<DeckAccuracy> getThisMonthAccuracy({required CardsDao cardsDao});

  Future<DeckAccuracy> getPreviousMonthAccuracy({required CardsDao cardsDao});

  Future<List<DeckAccuracy>> getWeeklyAccuracy({required CardsDao cardsDao});

  Future<List<DeckAccuracy>> getMonthlyAccuracy({required CardsDao cardsDao});

  Future<List<CardsDetailEntity>> getTop3MostAccurateCards({
    required CardsDao cardsDao,
  });
  Future<List<CardsDetailEntity>> getTop3LeastAccurateCards({
    required CardsDao cardsDao,
  });

  Future<DeckTimeConsume> getThisMonthTimeConsume({required CardsDao cardsDao});

  Future<DeckTimeConsume> getPreviousMonthTimeConsume({
    required CardsDao cardsDao,
  });

  Future<List<DeckTimeConsume>> getMonthlyTimeConsume({
    required CardsDao cardsDao,
  });

  Future<List<DeckTimeConsume>> getWeeklyTimeConsume({
    required CardsDao cardsDao,
  });
  Future<List<DeckTimeConsume>> getDailyTimeConsume({
    required CardsDao cardsDao,
  });
}
