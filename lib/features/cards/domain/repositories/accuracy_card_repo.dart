import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';

abstract class AccuracyCardRepo {
  Future<DeckAccuracy> getSingleAccuracy({
    required GroupedTimeEnum timeRange,
  });

  Stream<List<DeckAccuracy>> getGroupedAccuracy({
    required GroupedTimeEnum timeRange,
  });

  Future<List<CardsDetailEntity>> getAccuracyTopCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
  });
}
