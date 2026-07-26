import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/models/time_consume_model/time_consume_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../../../../../core/data/external_database/external_database.dart';
import '../../models/fetching_cards_model.dart';

part 'time_consume_dao.g.dart';

@DriftAccessor(tables: [CardsTable, NotesTable, RevlogTable])
class TimeConsumeDao extends DatabaseAccessor<ExternalDatabase>
    with _$TimeConsumeDaoMixin {
  TimeConsumeDao(super.attachedDatabase);

  Stream<List<TimeConsumeModel>> getGroupedTimeConsume({
    required GroupedTimeEnum timeRange,
  }) {
    final DateTime now = DateTime.now();
    int? start;
    int? end;
    switch (timeRange) {
      case GroupedTimeEnum.daily:
      case GroupedTimeEnum.weekly:
        start = getStartOfMonthEpoch(time: now);
        end = getStartOfNextMonthEpoch(time: now);

      case GroupedTimeEnum.monthly:
        start = getStartOfYearEpoch(time: now);
        end = getEndOfYearEpoch(time: now);
      default:
        start = getStartOfMonthEpoch(time: now);
        end = getStartOfNextMonthEpoch(time: now);
    }

    final query = (select(
      revlogTable,
    )..where((row) => row.id.isBetweenValues(start!, end!))).watch();

    return query.map((row) {
      return row.map((data) {
        return TimeConsumeModel(timeCode: data.id, timeSpent: data.time);
      }).toList();
    });
  }

  Future<List<TimeConsumeEntity>> getThisWeekStreakData() async {
    final now = DateTime.now();
    final DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final int begin = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    ).millisecondsSinceEpoch;
    final int end = begin + (7 * 24 * 60 * 60 * 1000);

    final query = select(revlogTable)
      ..where(
        (data) =>
            data.id.isBiggerOrEqualValue(begin) &
            data.id.isSmallerOrEqualValue(end),
      );

    final List<RevlogTableData> logs = await query.get();

    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final Map<String, List<int>> dayBuckets = {
      for (var name in dayNames) name: [],
    };

    for (var log in logs) {
      final date = DateTime.fromMillisecondsSinceEpoch(log.id);
      final dayKey = DateFormat.EEEE('en_US').format(date).substring(0, 3);
      dayBuckets[dayKey]?.add(log.time);
    }

    return dayNames.map((dayKey) {
      final times = dayBuckets[dayKey]!;
      if (times.isEmpty) {
        return TimeConsumeEntity(
          timeLabel: dayKey,
          avgTime: TimeUnit.fromMilliSeconds(0),
          totalTime: TimeUnit.fromMilliSeconds(0),
        );
      }
      final totalTimeMs = times.fold<int>(0, (sum, t) => sum + t);
      final avgTimeMs = totalTimeMs ~/ times.length;
      return TimeConsumeEntity(
        timeLabel: dayKey,
        avgTime: TimeUnit.fromMilliSeconds(avgTimeMs),
        totalTime: TimeUnit.fromMilliSeconds(totalTimeMs),
      );
    }).toList();
  }

  Future<List<CardsDetailEntity>> getTimeConsumeTopCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
    required int limit,
  }) async {
    final totalTime = revlogTable.time.sum();
    final query =
        select(revlogTable).join([
            innerJoin(cardsTable, revlogTable.cid.equalsExp(cardsTable.id)),
            innerJoin(notesTable, cardsTable.nid.equalsExp(notesTable.id)),
          ])
          ..addColumns([totalTime])
          ..where(revlogTable.id.isBetweenValues(begin, end))
          ..groupBy([revlogTable.cid])
          ..orderBy([
            orderBy == OrderEnums.asc
                ? OrderingTerm.asc(totalTime)
                : OrderingTerm.desc(totalTime),
          ])
          ..limit(limit);

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
