import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/models/accuracy_model/accuracy_model.dart';
import 'package:basa_app_project/features/cards/data/models/history_model/history_model.dart';
import 'package:basa_app_project/features/cards/data/models/time_consume_model/time_consume_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

part 'generated_database.g.dart';

class GeneratedCardsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get defaultLanguage => text()();

  TextColumn get translation => text()();

  TextColumn get additionalContext => text()();

  TextColumn get pronunciation => text()();

  IntColumn get score => integer().withDefault(const Constant(0))();

  @override
  String get tableName => 'cards';
}

class HistoryTable extends Table {
  IntColumn get idH => integer().autoIncrement()();

  IntColumn get idC => integer()();

  IntColumn get answer => integer()();

  IntColumn get totalTime => integer().withDefault(const Constant(0))();

  IntColumn get timeCode => integer()();

  @override
  String get tableName => 'history';
}

@DriftAccessor(tables: [GeneratedCardsTable, HistoryTable])
class GeneratedDeckDao extends DatabaseAccessor<GeneratedDeckDatabase>
    with _$GeneratedDeckDaoMixin {
  GeneratedDeckDao(super.attachedDatabase);

  Future<int> insertCard(GeneratedCardsTableCompanion entry) {
    return into(generatedCardsTable).insert(entry);
  }

  Future<int> insertHistory({
    required int idC,
    required bool isCorrect,
    required int totalTime,
  }) {
    return into(historyTable).insert(
      HistoryTableCompanion.insert(
        idC: idC,
        answer: isCorrect ? 1 : 0,
        totalTime: Value(totalTime),
        timeCode: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Future<List<CardsDetailEntity>> getAllCards() async {
    final rows = await (select(
      generatedCardsTable,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.id)])).get();

    return rows.map(_toEntity).toList();
  }

  Stream<List<CardsDetailEntity>> searchCard({required String searchParams}) {
    final query = select(generatedCardsTable)
      ..where(
        (row) =>
            row.defaultLanguage.like('%$searchParams%') |
            row.translation.like('%$searchParams%'),
      );

    return query.watch().map((rows) {
      return rows.map(_toEntity).toList();
    });
  }

  Future<CardsDetailEntity?> getCardById({required int cardId}) async {
    final row = await (select(
      generatedCardsTable,
    )..where((card) => card.id.equals(cardId))).getSingleOrNull();

    if (row == null) return null;

    return _toEntity(row);
  }

  Future<void> updateScore({
    required int cardId,
    required bool isCorrect,
  }) async {
    final current = await (select(
      generatedCardsTable,
    )..where((card) => card.id.equals(cardId))).getSingleOrNull();

    if (current == null) return;

    await (update(
      generatedCardsTable,
    )..where((card) => card.id.equals(cardId))).write(
      GeneratedCardsTableCompanion(
        score: Value(current.score + (isCorrect ? 1 : 0)),
      ),
    );
  }

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
      historyTable,
    )..where((row) => row.timeCode.isBetweenValues(start, end))).watch();

    return query.map((rows) {
      return rows.map((data) {
        return AccuracyModel(
          timeCode: data.timeCode,
          ease: data.answer == 1 ? 3 : 1,
        );
      }).toList();
    });
  }

  Future<List<CardsDetailEntity>> getMostInaccurateCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
    int? limit,
  }) async {
    final wrongCount = historyTable.answer.equals(0).cast<int>().sum();
    final rawQuery =
        select(historyTable).join([
            innerJoin(
              generatedCardsTable,
              historyTable.idC.equalsExp(generatedCardsTable.id),
            ),
          ])
          ..addColumns([wrongCount])
          ..where(
            historyTable.timeCode.isBetweenValues(begin, end) &
                historyTable.answer.equals(0),
          )
          ..groupBy([historyTable.idC])
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
      final cardTable = result.readTable(generatedCardsTable);

      return _toEntity(cardTable);
    }).toList();
  }

  Future<int> getReviewedCardsCount({
    required int begin,
    required int end,
  }) async {
    final countExp = historyTable.idC.count(distinct: true);

    final query = selectOnly(historyTable)
      ..addColumns([countExp])
      ..where(historyTable.timeCode.isBetweenValues(begin, end));

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<TimeUnit> getTotalTimeByTimeRange({
    required int begin,
    required int end,
  }) async {
    final totalTime = historyTable.totalTime.sum();

    final query = selectOnly(historyTable)
      ..addColumns([totalTime])
      ..where(historyTable.timeCode.isBetweenValues(begin, end));

    final result = await query.getSingle();
    return TimeUnit.fromMilliSeconds(result.read(totalTime) ?? 0);
  }

  Future<int> getAverageNumber({required int begin, required int end}) async {
    final correctCount = historyTable.answer.equals(1).cast<int>().sum();
    final totalCard = historyTable.idC.count();

    final query = selectOnly(historyTable)
      ..addColumns([correctCount, totalCard])
      ..where(historyTable.timeCode.isBetweenValues(begin, end));

    final result = await query.getSingle();

    final int correct = result.read(correctCount) ?? 0;
    final int total = result.read(totalCard) ?? 0;

    if (total == 0) return 0;

    final double average = (correct / total) * 100;

    return average.round();
  }

  Stream<List<TimeConsumeModel>> getGroupedTimeConsume({
    required GroupedTimeEnum timeRange,
  }) {
    final DateTime now = DateTime.now();
    int? start;
    int? end;
    switch (timeRange) {
      case GroupedTimeEnum.daily:
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
      historyTable,
    )..where((row) => row.timeCode.isBetweenValues(start!, end!))).watch();

    return query.map((rows) {
      return rows.map((data) {
        return TimeConsumeModel(
          timeCode: data.timeCode,
          timeSpent: data.totalTime,
        );
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

    final query = select(historyTable)
      ..where(
        (data) =>
            data.timeCode.isBiggerOrEqualValue(begin) &
            data.timeCode.isSmallerOrEqualValue(end),
      );

    final List<HistoryTableData> logs = await query.get();

    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final Map<String, List<int>> dayBuckets = {
      for (var name in dayNames) name: [],
    };

    for (var log in logs) {
      final date = DateTime.fromMillisecondsSinceEpoch(log.timeCode);
      final dayKey = DateFormat.EEEE('en_US').format(date).substring(0, 3);
      dayBuckets[dayKey]?.add(log.totalTime);
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

  Future<List<TopCardsTimeConsumeEntity>> getTimeConsumeTopCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
    required int limit,
  }) async {
    final totalTime = historyTable.totalTime.sum();
    final query =
        select(historyTable).join([
            innerJoin(
              generatedCardsTable,
              historyTable.idC.equalsExp(generatedCardsTable.id),
            ),
          ])
          ..addColumns([totalTime])
          ..where(historyTable.timeCode.isBetweenValues(begin, end))
          ..groupBy([historyTable.idC])
          ..orderBy([
            orderBy == OrderEnums.asc
                ? OrderingTerm.asc(totalTime)
                : OrderingTerm.desc(totalTime),
          ])
          ..limit(limit);

    final List<TypedResult> results = await query.get();

    if (results.isEmpty) return [];

    return results.map((result) {
      final cardTable = result.readTable(generatedCardsTable);
      final historyRow = result.readTable(historyTable);

      return TopCardsTimeConsumeModel(
        timeCode: historyRow.timeCode,
        card: _toEntity(cardTable),
        timeSpent: historyRow.totalTime,
      ).toEntity();
    }).toList();
  }

  Future<int> getReviewedCardsCountByTimeConsume({
    required int begin,
    required int end,
  }) async {
    final countExp = historyTable.idC.count(distinct: true);

    final query = selectOnly(historyTable)
      ..addColumns([countExp])
      ..where(historyTable.timeCode.isBetweenValues(begin, end));

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<TimeUnit> getAverageTimeByTimeRange({
    required int begin,
    required int end,
  }) async {
    final totalTime = historyTable.totalTime.sum();
    final totalReview = historyTable.idC.count();

    final query = selectOnly(historyTable)
      ..addColumns([totalTime, totalReview])
      ..where(historyTable.timeCode.isBetweenValues(begin, end));

    final result = await query.getSingle();

    final int time = result.read(totalTime) ?? 0;
    final int count = result.read(totalReview) ?? 0;

    if (count == 0) return TimeUnit.fromMilliSeconds(0);
    return TimeUnit.fromMilliSeconds(time ~/ count);
  }

  Future<List<HistoryModel>> getHistory({
    required int start,
    required int end,
  }) async {
    final query = select(historyTable).join([
      innerJoin(
        generatedCardsTable,
        historyTable.idC.equalsExp(generatedCardsTable.id),
      ),
    ])..where(historyTable.timeCode.isBetweenValues(start, end));

    final List<TypedResult> results = await query.get();

    if (results.isEmpty) return [];

    return results.map((result) {
      final cardTable = result.readTable(generatedCardsTable);
      final historyRow = result.readTable(historyTable);

      return HistoryModel(
        timeCodeMs: historyRow.timeCode,
        card: _toEntity(cardTable),
      );
    }).toList();
  }

  CardsDetailEntity _toEntity(GeneratedCardsTableData row) {
    return CardsDetailEntity(
      id: row.id,
      defaultLanguage: row.defaultLanguage,
      translatedLanguage: row.translation,
      additionalContext: row.additionalContext,
      pronunciation: row.pronunciation,
    );
  }
}

@DriftDatabase(
  tables: [GeneratedCardsTable, HistoryTable],
  daos: [GeneratedDeckDao],
)
class GeneratedDeckDatabase extends _$GeneratedDeckDatabase {
  GeneratedDeckDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      await m.drop(generatedCardsTable);
      await m.drop(historyTable);
      await m.createAll();
    },
  );
}
