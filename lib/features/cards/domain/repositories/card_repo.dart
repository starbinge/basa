import 'package:basa_app_project/features/cards/data/models/fetching_cards_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_entity.dart';

abstract class CardRepo {
  Future<CardsEntity> fetchCards({required int deckId});
  Future<CardsModel?> getCardById({required int cardId});}
