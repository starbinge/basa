import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/models/accuracy_model/accuracy_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';
import 'package:drift/drift.dart';

import '../../../../../core/data/external_database/external_database.dart';
import '../../models/fetching_cards_model.dart';

part 'accuracy_dao.g.dart';

@DriftAccessor(tables: [CardsTable, NotesTable, RevlogTable])
class AccuracyDao extends DatabaseAccessor<ExternalDatabase>
    with _$AccuracyDaoMixin {
  AccuracyDao(super.attachedDatabase);

  Stream<List<AccuracyModel>> getAccuracyData({
    required GroupedTimeEnum timeRange,
  }) {
    final DateTime now = DateTime.now();
    int start;
    int end;
    switch (timeRange) {
      case GroupedTimeEnum.daily:
      case GroupedTimeEnum.weekly:
        start = getStartOfMonthEpoch(time: now);
        end = getStartOfNextMonthEpoch(time: now);
      case GroupedTimeEnum.monthly:
        start = getStartOfYearEpoch(time: now);
        end = getEndOfYearEpoch(time: now);
      case GroupedTimeEnum.thisMonth:
        start = getStartOfMonthEpoch(time: now);
        end = getStartOfNextMonthEpoch(time: now);
      case GroupedTimeEnum.previousMonth:
        final DateTime lastMonth = DateTime(now.year, now.month - 1);
        start = getStartOfMonthEpoch(time: lastMonth);
        end = getStartOfNextMonthEpoch(time: lastMonth);
      default:
        start = getStartOfMonthEpoch(time: now);
        end = getStartOfNextMonthEpoch(time: now);
    }

    final query = (select(revlogTable)
      ..where((row) => row.id.isBetweenValues(start, end)))
        .watch();

    return query.map((row) {
      return row.map((data) {
        return AccuracyModel(timeCode: data.id, ease: data.ease);
      }).toList();
    });
  }

  Future<List<CardsDetailEntity>> getAccuracyTopCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
  }) async {
    final correctCount = revlogTable.ease.equals(3).cast<int>().sum();
    final query =
        select(revlogTable).join([
            innerJoin(cardsTable, revlogTable.cid.equalsExp(cardsTable.id)),
            innerJoin(notesTable, cardsTable.nid.equalsExp(notesTable.id)),
          ])
          ..addColumns([correctCount])
          ..where(revlogTable.id.isBetweenValues(begin, end))
          ..groupBy([revlogTable.cid])
          ..orderBy([
            orderBy == OrderEnums.asc
                ? OrderingTerm.asc(correctCount)
                : OrderingTerm.desc(correctCount),
          ])
          ..limit(3);

    final List<TypedResult> results = await query.get();

    if (results.isEmpty) return [];

    return results.map((result) {
      final CardsTableData cardTable = result.readTable(cardsTable);
      final NotesTableData noteTable = result.readTable(notesTable);

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

      return model.toEntity();
    }).toList();
  }
}
