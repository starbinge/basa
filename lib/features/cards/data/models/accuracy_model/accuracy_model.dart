import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';

class AccuracyModel {
  final int timeCode;
  final int ease;

  AccuracyModel({required this.timeCode, required this.ease});
}

class TopCardAccuracyModel {
  final int accuracyNumber;
  final CardsDetailEntity card;

  TopCardAccuracyModel({required this.accuracyNumber, required this.card});
}
