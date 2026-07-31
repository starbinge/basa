import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';

abstract class AccuracyCardRepo {
  Stream<DeckAccuracy> getSingleAccuracy({required GroupedTimeEnum timeRange});

  Stream<List<DeckAccuracy>> getGroupedAccuracy({
    required GroupedTimeEnum timeRange,
  });

  Future<List<CardsDetailEntity>> getAccuracyTopCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
  });

  Future<int> getAvgAccuracyByTimeRange({
    required begin,
    required end,
  });

  Future<int> getTotalCardsByTimeRange({required begin, required end});

  Future<TimeUnit> getTotalTimeByTimeRange({required begin, required end});
}
