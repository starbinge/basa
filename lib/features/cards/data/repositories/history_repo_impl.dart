import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/data/dao/history_dao/history_dao.dart';
import 'package:basa_app_project/features/cards/data/models/history_model/history_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/history_entity/history_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/history_card_repo.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';

class HistoryRepoImpl implements HistoryCardRepo {
  final HistoryDao _historyDao;

  HistoryRepoImpl({required HistoryDao historyDao}) : _historyDao = historyDao;

  @override
  Future<HistoryEntity> getHistoryByTimeRange({
    required GroupedTimeEnum groupBy,
  }) async {
    final DateTime now = DateTime.now();
    final String timeLabel;
    final int start;
    final int end;

    switch (groupBy) {
      case GroupedTimeEnum.today:
        start = getStartOfTodayEpoch(time: now);
        end = getEndOfTodayEpoch(time: now);
        timeLabel = "Today History";
      case GroupedTimeEnum.daily:
        start = getStartOfMonthEpoch(time: now);
        end = getStartOfNextMonthEpoch(time: now);
        timeLabel = "Daily History";
      case GroupedTimeEnum.weekly:
        start = getStartOfWeekEpoch(time: now);
        end = getEndOfWeekEpoch(time: now);
        timeLabel = "Weekly History";
      case GroupedTimeEnum.monthly:
      case GroupedTimeEnum.thisMonth:
        start = getStartOfMonthEpoch(time: now);
        end = getStartOfNextMonthEpoch(time: now);
        timeLabel = "Monthly History";
      case GroupedTimeEnum.previousMonth:
        timeLabel = "Previous Month History";
        start = getStartOfPreviousMonthEpoch(time: now);
        end = getStartOfMonthEpoch(time: now);
    }
    final List<HistoryModel> rawData = await _historyDao.getHistory(
      start: start,
      end: end,
    );

    return HistoryEntity(
      labelTime: timeLabel,
      listCards: rawData.map((data) => data.card).toList(),
    );
  }
}
