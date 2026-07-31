import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';

class HistoryEntity {
  final String labelTime;
  final List<CardsDetailEntity> listCards;

  HistoryEntity({required this.labelTime, required this.listCards});
}