import '../../../../core/data/initial_database/initial_database.dart';

abstract class DeckRepository {
  Future<List<ImportedDeckData>> getAll();

  Future<bool> isDeckExists(String deckName);

  Future<void> importDeck({
    required String deckName,
    required String deckFilePath,
    required int deckColor,
    required String deckLanguage,
    String explanationRolePlay = '',
  });

  Future<int> updatingActiveHour({
    required int deckId,
    required int additionalHours,
  });

  Future<void> generateDeck({
    required Map<String, dynamic> jsonData,
    required String deckName,
    required int colorDeck,
    required String countryDeck,
  });
}
