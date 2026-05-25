import 'cards_detail_entity.dart';

class CardsEntity {
  final String deckName;
  final String deckCountry;
  final List<CardsDetailEntity> listCard;

  CardsEntity({
    required this.deckName,
    required this.deckCountry,
    required this.listCard,
  });
}
