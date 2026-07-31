import '../../../domain/entities/cards_detail_entity.dart';

class HistoryModel {
  final int timeCodeMs;
  final CardsDetailEntity card;

  HistoryModel({required this.timeCodeMs, required this.card});

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      timeCodeMs: map['timeCodeMs'] as int,
      card: map['card'],
    );
  }

  Map<String, dynamic> toMap() => {
    'timeCodeMs': timeCodeMs,
    'card': this.card.toMap(),
  };
}
