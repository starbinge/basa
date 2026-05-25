import 'package:basa_app_project/core/database/initial_database/initial_database.dart';
import 'package:drift/drift.dart';

import '../models/deck_model.dart';

part 'decks_dao.g.dart';

@DriftAccessor(tables: [ImportedDeck])
class DecksDao extends DatabaseAccessor<AppDatabase> with _$DecksDaoMixin {
  DecksDao(super.attachedDatabase);

  //getting all deck query
  Future<List<ImportedDeckData>> getAll() => select(importedDeck).get();

  Future<int> insertNewDeck(ImportedDeckCompanion entry) {
    return into(importedDeck).insert(entry);
  }

  Future<ImportedDeckData> getDeckFilePathById({required int id}) {
    return (select(
      importedDeck,
    )..where((data) => data.id.equals(id))).getSingle();
  }
}
