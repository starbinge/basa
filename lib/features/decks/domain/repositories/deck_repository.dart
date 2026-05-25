import 'package:basa_app_project/core/database/initial_database/initial_database.dart';

abstract class DeckRepository {
  Future<List<ImportedDeckData>> getAll();
  Future<bool> isDeckExists(String deckName);
  Future<void> importDeck({
    required String deckName,
    required String deckFilePath,
    required String deckLanguage,
    required int deckColor,
  });
}
