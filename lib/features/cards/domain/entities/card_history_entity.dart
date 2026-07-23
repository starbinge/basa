import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';

class CardHistoryEntity {
  final List<CardsDetailEntity> weeklyHistory;
  final List<CardsDetailEntity> todayHistory;
  final List<CardsDetailEntity> monthlyHistory;

  CardHistoryEntity({
    required this.weeklyHistory,
    required this.todayHistory,
    required this.monthlyHistory,
  });
}
