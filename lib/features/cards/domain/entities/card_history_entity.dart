import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';

class CardHistoryEntity {
  final List<CardsDetailEntity> weeklyHistory;
  final List<CardsDetailEntity> todayHistory;

  CardHistoryEntity({required this.weeklyHistory, required this.todayHistory});
}
