import 'package:drift/drift.dart';

import '../../../../core/data/initial_database/initial_database.dart';
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

  Future<int> updatingActiveHour({
    required int deckId,
    required int additionalHours,
  }) async {
    return customUpdate(
      'UPDATE imported_deck SET active_hour = active_hour + ? WHERE id = ?',
      variables: [Variable(additionalHours), Variable(deckId)],
    );
  }

  Future<ImportedDeckData> getDeckFilePathById({required int id}) {
    return (select(
      importedDeck,
    )..where((data) => data.id.equals(id))).getSingle();
  }
}
