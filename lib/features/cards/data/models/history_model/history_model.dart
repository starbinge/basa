import '../../../domain/entities/cards_detail_entity.dart';

class HistoryModel {
  final int timeCodeMs;
  final CardsDetailEntity card;

  HistoryModel({required this.timeCodeMs, required this.card});
}
