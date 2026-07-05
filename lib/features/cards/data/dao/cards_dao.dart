import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/data/external_database/external_database.dart';
import '../models/fetching_cards_model.dart';

part 'cards_dao.g.dart';

@DriftAccessor(tables: [CardsTable, NotesTable])
class CardsDao extends DatabaseAccessor<ExternalDatabase> with _$CardsDaoMixin {
  CardsDao(super.attachedDatabase);

  Future<List<CardsModel>> getCards() async {
    final cardsTableData = select(
      cardsTable,
    ).join([innerJoin(notesTable, notesTable.id.equalsExp(cardsTable.nid))]);
    final List<TypedResult> tables = await cardsTableData.get();
    return tables.map((table) {
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
    });
  }

  Future<int> updateCards({
    required CardsTableCompanion updatedCardValue,
  }) async {
    return (update(cardsTable)
          ..where((card) => card.id.equals(updatedCardValue.id.value)))
        .write(updatedCardValue);
  }
}
