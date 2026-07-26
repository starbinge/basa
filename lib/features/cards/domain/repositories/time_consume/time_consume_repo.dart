import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';

abstract class TimeConsumeRepo {
  Stream<List<TimeConsumeEntity>> getGroupedTimeConsume({
    required GroupedTimeEnum timeRange,
  });

  Future<TimeConsumeEntity> getSingleTimeConsume({
    required GroupedTimeEnum timeRange,
  });

  Future<List<TimeConsumeEntity>> getThisWeekStreakData();

  Future<List<CardsDetailEntity>> getTimeConsumeTopCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
  });
}
