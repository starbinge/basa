import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/models/accuracy_model/accuracy_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
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

    final query = (select(
      revlogTable,
    )..where((row) => row.id.isBetweenValues(start, end))).watch();

    return query.map((row) {
      return row.map((data) {
        return AccuracyModel(timeCode: data.id, ease: data.ease);
      }).toList();
    });
  }

  Future<List<CardsDetailEntity>> getMostInaccurateCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
    int? limit,
  }) async {
    final wrongCount = revlogTable.ease.equals(1).cast<int>().sum();
    final rawQuery =
        select(revlogTable).join([
            innerJoin(cardsTable, revlogTable.cid.equalsExp(cardsTable.id)),
            innerJoin(notesTable, cardsTable.nid.equalsExp(notesTable.id)),
          ])
          ..addColumns([wrongCount])
          ..where(
            revlogTable.id.isBetweenValues(begin, end) &
                revlogTable.ease.equals(1),
          )
          ..groupBy([revlogTable.cid])
          ..orderBy([
            orderBy == OrderEnums.asc
                ? OrderingTerm.asc(wrongCount)
                : OrderingTerm.desc(wrongCount),
          ]);
    if (limit != null) {
      rawQuery.limit(limit);
    }

    final List<TypedResult> results = await rawQuery.get();

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

  Future<int> getReviewedCardsCount({
    required int begin,
    required int end,
  }) async {
    final countExp = revlogTable.cid.count(distinct: true);

    final query = selectOnly(revlogTable)
      ..addColumns([countExp])
      ..where(revlogTable.id.isBetweenValues(begin, end));

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<TimeUnit> getTotalTimeByTimeRange({
    required int begin,
    required int end,
  }) async {
    final totalTime = revlogTable.time.sum();

    final query = selectOnly(revlogTable)
      ..addColumns([totalTime])
      ..where(revlogTable.id.isBetweenValues(begin, end));

    final result = await query.getSingle();
    return TimeUnit.fromMilliSeconds(result.read(totalTime) ?? 0);
  }

  Future<int> getAverageNumber({required int begin, required int end}) async {
    final correctCount = revlogTable.ease.equals(3).cast<int>().sum();
    final totalCard = revlogTable.id.count();

    final query = selectOnly(revlogTable)
      ..addColumns([correctCount, totalCard])
      ..where(revlogTable.id.isBetweenValues(begin, end));

    final result = await query.getSingle();

    final int correct = result.read(correctCount) ?? 0;
    final int total = result.read(totalCard) ?? 0;

    if (total == 0) return 0;

    final double average = (correct / total) * 100;

    return average.round();
  }
}
