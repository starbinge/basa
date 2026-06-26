import 'package:basa_app_project/core/database/external_database/external_database.dart';
import 'package:basa_app_project/core/database/initial_database/initial_database.dart';
import 'package:basa_app_project/core/services/anki_media_service.dart';
import 'package:basa_app_project/core/utils/fields_splitter.dart';
import 'package:basa_app_project/core/utils/html_cleaner.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/data/models/fetching_cards_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/audio_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/card_repo.dart';
import 'package:basa_app_project/core/services/external_database_accessor.dart';
import 'package:basa_app_project/features/decks/data/dao/decks_dao.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;

class CardRepoImpl implements CardRepo {
  final DecksDao _decksDao;
  final CardsDao _cardsDao;
  CardsModel? _cardById;
  CardRepoImpl({required DecksDao decksDao, required CardsDao cardsDao}) : _cardsDao = cardsDao, _decksDao = decksDao;


  @override
  Future<CardsEntity> fetchCards({required int deckId}) {
    // TODO: implement fetchCards
    throw UnimplementedError();
  }

  @override
  Future<CardsModel?> getCardById({required int cardId}) async {
    return _cardById = await _cardsDao.getCardById(cardId: cardId);
  }

  CardsModel? get oneCardById => _cardById;
}
