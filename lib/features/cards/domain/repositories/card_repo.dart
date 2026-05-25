import 'package:basa_app_project/features/cards/domain/entities/cards_entity.dart';

abstract class CardRepo {
  Future<CardsEntity> fetchCards({required int deckId});
}
