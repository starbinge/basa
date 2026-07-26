import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/data/external_database/external_database.dart';
import '../../models/fetching_cards_model.dart';

part 'cards_dao.g.dart';

@DriftAccessor(tables: [CardsTable, NotesTable, RevlogTable])
class CardsDao extends DatabaseAccessor<ExternalDatabase> with _$CardsDaoMixin {
  CardsDao(super.attachedDatabase);

  Future<List<CardsModel>> getCards(int limit, {int? offset}) async {
    final query =
        select(cardsTable).join([
            innerJoin(notesTable, notesTable.id.equalsExp(cardsTable.nid)),
          ])
          ..orderBy([OrderingTerm.asc(cardsTable.queue)])
          ..limit(limit, offset: offset);
    final result = await query.get();
    return result.map((table) {
      final card = table.readTable(cardsTable);
      final note = table.readTable(notesTable);
      return CardsModel.fromMap({
        'card_id': card.id,
        'nid': note.id,
        'queue': card.queue,
        'flds': note.flds,
        'tags': note.tags,
        'ivl': card.ivl,
        'odue': card.odue,
        'factor': card.factor,
        'left': card.left,
        'reps': card.reps,
        'flags': card.flags,
      });
    }).toList();
  }

  Future<CardsModel?> getCardById({required int cardId}) async {
    final cardsTableData = select(
      cardsTable,
    ).join([innerJoin(notesTable, notesTable.id.equalsExp(cardsTable.nid))]);
    cardsTableData.where(cardsTable.id.equals(cardId));
    final List<TypedResult> rows = await cardsTableData.get();

    if (rows.isEmpty) {
      debugPrint("Data gaaada");
      return null;
    }

    final firstRow = rows.first;
    final cardRow = firstRow.readTable(cardsTable);
    final noteRow = firstRow.readTable(notesTable);

    return CardsModel.fromMap({
      'card_id': cardRow.id,
      'nid': noteRow.id,
      'queue': cardRow.queue,
      'flds': noteRow.flds,
      'tags': noteRow.tags,
      'ivl': cardRow.ivl,
      'odue': cardRow.odue,
      'factor': cardRow.factor,
      'left': cardRow.left,
      'reps': cardRow.reps,
      'flags': cardRow.flags,
    });
  }

  Future<int> updateCards({
    required CardsTableCompanion updatedCardValue,
  }) async {
    return (update(cardsTable)
          ..where((card) => card.id.equals(updatedCardValue.id.value)))
        .write(updatedCardValue);
  }

  Future<int> insertRevlog(RevlogTableCompanion data) async {
    return into(revlogTable).insert(data);
  }
}
