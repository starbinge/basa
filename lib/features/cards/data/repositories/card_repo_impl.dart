import 'package:basa_app_project/features/cards/data/dao/cards_dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/data/models/fetching_cards_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/card_repo.dart';
import 'package:basa_app_project/features/decks/data/dao/decks_dao.dart';

class CardRepoImpl implements CardRepo {
  final CardsDao _cardsDao;
  CardsModel? _cardById;

  CardRepoImpl({required DecksDao decksDao, required CardsDao cardsDao})
    : _cardsDao = cardsDao;

  //Fetching all cards based on deckId
  @override
  Future<CardsEntity> fetchCards({
    required int deckId,
    required String deckName,
    required String deckCountry,
  }) async {
    try {
      final List<CardsModel> _cardsModel = await _cardsDao.getCards(50);
      final List<CardsDetailEntity> _listCard = _cardsModel
          .map((card) => card.toEntity())
          .toList();
      return CardsEntity(
        deckName: deckName,
        deckCountry: deckCountry,
        listCard: _listCard,
      );
    } on UnimplementedError {
      throw UnimplementedError();
    }
  }

  @override
  Future<CardsModel?> getCardById({required int cardId}) async {
    return _cardById = await _cardsDao.getCardById(cardId: cardId);
  }

  CardsModel? get oneCardById => _cardById;
}
