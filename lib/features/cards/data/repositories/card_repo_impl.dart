import 'package:basa_app_project/core/database/external_database/external_database.dart';
import 'package:basa_app_project/core/database/initial_database/initial_database.dart';
import 'package:basa_app_project/core/services/anki_media_service.dart';
import 'package:basa_app_project/core/utils/fields_splitter.dart';
import 'package:basa_app_project/core/utils/html_cleaner.dart';
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

  CardRepoImpl({required DecksDao decksDao}) : _decksDao = decksDao;

  @override
  Future<CardsEntity> fetchCards({required int deckId}) async {
    final ImportedDeckData _selectedRow = await _decksDao.getDeckFilePathById(
      id: deckId,
    );
    debugPrint(_selectedRow.extractedPath);
    AnkiMediaService _ankiMediaService = AnkiMediaService();
    await _ankiMediaService.findAudioPath(
      mediaInformationSource: path.join(_selectedRow.extractedPath, "media"),
    );
    final String _extractedSelectedCardsPath = path.join(
      _selectedRow.extractedPath,
      "collection.anki2",
    );
    debugPrint(_extractedSelectedCardsPath);
    try {
      final ExternalDatabase _selectedData =
          ExternalDatabaseAccessor.openConnectionFromFile(
            dbPath: _extractedSelectedCardsPath,
          );
      final List<TypedResult> _rawData =
          await _selectedData.select(_selectedData.cardsTable).join([
            innerJoin(
              _selectedData.notesTable,
              _selectedData.notesTable.id.equalsExp(
                _selectedData.cardsTable.nid,
              ),
            ),
          ]).get();
      final List<CardsDetailEntity> _listCards = _rawData.map((data) {
        final cardRows = data.readTable(_selectedData.cardsTable);
        final noteRows = data.readTable(_selectedData.notesTable);
        final List<String> fields = fieldSplitter(
          text: noteRows.flds.toString(),
        );
        final String defaultLang = fields.isNotEmpty ? fields[0] : "";
        final String translatedLang = fields.isNotEmpty ? fields[1] : "";
        final String maleVoice = fields.isNotEmpty
            ? _ankiMediaService.mediaMap[cleanAudioHtml(
                rawAudioText: fields[2],
              )]!
            : "";
        final String femaleVoice = fields.isNotEmpty
            ? _ankiMediaService.mediaMap[cleanAudioHtml(
                rawAudioText: fields[3],
              )]!
            : "";
        final String explanation = fields.isNotEmpty ? fields[4] : "";
        final String pronunciation = fields.isNotEmpty ? fields[5] : "";
        return CardsDetailEntity(
          defaultLanguage: cleanHtml(text: defaultLang),
          translatedLanguage: cleanHtml(text: translatedLang),
          audioPath: AudioEntity(
            maleVoice: path.join(_selectedRow.extractedPath, maleVoice),
            femaleVoice: path.join(_selectedRow.extractedPath, femaleVoice),
          ),
          accuracyPercentage: (cardRows.factor / 100).round(),
          activeRepetition: cardRows.reps,
          cardsId: cardRows.nid,
          explanation: explanation,
          pronunciation: pronunciation,
        );
      }).toList();
      return CardsEntity(
        deckName: _selectedRow.deckName,
        deckCountry: _selectedRow.deckLanguage,
        listCard: _listCards,
      );
    } catch (e) {
      return CardsEntity(deckName: "", deckCountry: "", listCard: []);
    }
  }
}
