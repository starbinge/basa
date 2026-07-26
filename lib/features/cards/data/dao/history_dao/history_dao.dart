import 'package:basa_app_project/features/cards/data/models/history_model/history_model.dart';
import 'package:drift/drift.dart';

import '../../../../../core/data/external_database/external_database.dart';
import '../../models/fetching_cards_model.dart';

part 'history_dao.g.dart';

@DriftAccessor(tables: [CardsTable, NotesTable, RevlogTable])
class HistoryDao extends DatabaseAccessor<ExternalDatabase>
    with _$HistoryDaoMixin {
  HistoryDao(super.attachedDatabase);

  Future<List<HistoryModel>> getHistory({
    required int start,
    required int end,
  }) async {
    final query = select(revlogTable).join([
      innerJoin(cardsTable, revlogTable.cid.equalsExp(cardsTable.id)),
      innerJoin(notesTable, cardsTable.nid.equalsExp(notesTable.id)),
    ])..where(revlogTable.id.isBetweenValues(start, end));

    final List<TypedResult> results = await query.get();

    if (results.isEmpty) return [];

    return results.map((result) {
      final CardsTableData cardTable = result.readTable(cardsTable);
      final NotesTableData noteTable = result.readTable(notesTable);
      final RevlogTableData revlogRow = result.readTable(revlogTable);

      final model = CardsModel.fromMap({
        'card_id': cardTable.id,
        'nid': noteTable.id,
        'queue': cardTable.queue,
        'flds': noteTable.flds,
        'tags': noteTable.tags,
        'ivl': cardTable.ivl,
        'odue': cardTable.odue,
        'factor': cardTable.factor,
        'left': cardTable.left,
        'reps': cardTable.reps,
        'flags': cardTable.flags,
      });

      return HistoryModel.fromMap({
        'timeCodeMs': revlogRow.id,
        'card': model.toEntity(),
      });
    }).toList();
  }
}
