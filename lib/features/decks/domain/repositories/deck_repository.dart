import 'dart:io';

import '../../../../core/data/initial_database/initial_database.dart';

abstract class DeckRepository {
  Future<List<ImportedDeckData>> getAll();

  Future<bool> isDeckExists(String deckName);

  Future<void> importDeck({
    required String deckName,
    required String deckFilePath,
    required String deckLanguage,
    required int deckColor,
  });

  Future<int> updatingActiveHour({
    required int deckId,
    required int additionalHours,
  });

  Future<void> reConstructData({
    required File mediaFile,
    required File extractedFilePath,
  });
}
