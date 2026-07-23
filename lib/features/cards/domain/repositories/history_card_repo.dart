import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';

abstract class HistoryCardRepo {
  Future<List<CardsDetailEntity>> getWeeklyHistory({
    required final int start,
    required final int end,
    required final int limit,
    required CardsDao cardsDao,
  });
  Future<List<CardsDetailEntity>> getMonthlyHistory({
    required final int start,
    required final int end,
    required final int limit,
    required CardsDao cardsDao,
  });

  Future<List<CardsDetailEntity>> getTodayHistory({
    required final int start,
    required final int end,
    required final int limit,
    required CardsDao cardsDao,
  });
}
