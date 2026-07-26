import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/domain/entities/history_entity/history_entity.dart';

abstract class HistoryCardRepo {
  Future<HistoryEntity> getHistoryByTimeRange({
    required GroupedTimeEnum groupBy,
  });
}
