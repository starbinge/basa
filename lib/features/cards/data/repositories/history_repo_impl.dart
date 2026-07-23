import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/history_card_repo.dart';

class HistoryRepoImpl implements HistoryCardRepo {
  @override
  Future<List<CardsDetailEntity>> getMonthlyHistory({
    required int start,
    required int end,
    required int limit,
    required CardsDao cardsDao,
  }) async {
    return await cardsDao.getTimeConsumeTopCards(
      begin: start,
      end: end,
      orderBy: OrderEnums.desc,
      limit: limit,
    );
  }

  @override
  Future<List<CardsDetailEntity>> getWeeklyHistory({
    required int start,
    required int end,
    required int limit,
    required CardsDao cardsDao,
  }) async {
    return await cardsDao.getTimeConsumeTopCards(
      begin: start,
      end: end,
      orderBy: OrderEnums.desc,
      limit: limit,
    );
  }

  @override
  Future<List<CardsDetailEntity>> getTodayHistory({
    required int start,
    required int end,
    required int limit,
    required CardsDao cardsDao,
  }) async {
    return await cardsDao.getTimeConsumeTopCards(
      begin: start,
      end: end,
      orderBy: OrderEnums.desc,
      limit: limit,
    );
  }
}
