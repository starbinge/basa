import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/models/flashcard_statistic_model.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/get_start_end_date.dart';
import 'package:basa_app_project/features/cards/domain/usecases/time_range_generator_usecase.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../../core/data/external_database/external_database.dart';
import '../models/fetching_cards_model.dart';

part 'cards_dao.g.dart';

@DriftAccessor(tables: [CardsTable, NotesTable, RevlogTable])
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

  //AKURASI BULAN IN I
  Future<DeckAccuracy> getThisMonthAccuracy() async {
    final DateTime _now = DateTime.now();
    final int _begin = getStartOfMonthEpoch(time: _now);
    final int _end = getStartOfNextMonthEpoch(time: _now);

    final totalCards = revlogTable.id.count();
    final correctCards = revlogTable.ease.equals(3).cast<double>().sum();
    final _avgAccuracy =
        (correctCards * Variable(100.0)) / totalCards.cast<double>();

    final query = selectOnly(revlogTable)
      ..addColumns([_avgAccuracy])
      ..where(
        revlogTable.id.isBiggerOrEqualValue(_begin) &
            revlogTable.id.isSmallerOrEqualValue(_end),
      );

    final result = await query.getSingleOrNull();
    final double avg = result?.read(_avgAccuracy) ?? 0;
    return DeckAccuracy(
      timeName: DateFormat.MMMM('en_US').format(_now),
      accuracyNumber: avg.round(),
    );
  }

  //AKURASI BULAN LALU

  Future<DeckAccuracy> getPreviousMonthAccuracy() async {
    final DateTime _now = DateTime.now();
    final DateTime _lastMonth = DateTime(_now.year, _now.month - 1);
    final int _begin = getStartOfMonthEpoch(time: _lastMonth);
    final int _end = getStartOfNextMonthEpoch(time: _lastMonth);

    final totalCards = revlogTable.id.count();
    final correctCards = revlogTable.ease.equals(3).cast<double>().sum();
    final _avgAccuracy =
        (correctCards * Variable(100.0)) / totalCards.cast<double>();

    final query = selectOnly(revlogTable)
      ..addColumns([_avgAccuracy])
      ..where(
        revlogTable.id.isBiggerOrEqualValue(_begin) &
            revlogTable.id.isSmallerOrEqualValue(_end),
      );

    final result = await query.getSingleOrNull();
    final double avg = result?.read(_avgAccuracy) ?? 0;
    return DeckAccuracy(
      timeName: DateFormat.MMMM('en_US').format(_lastMonth),
      accuracyNumber: avg.round(),
    );
  }

  // ACCURACY PER-BULAN
  Future<List<DeckAccuracy>> getMonthlyAccuracy() async {
    final int currentYear = DateTime.now().year;
    final int _begin = DateTime(currentYear, 1, 1).millisecondsSinceEpoch;
    final int _end = DateTime(currentYear + 1, 1, 1).millisecondsSinceEpoch;

    final query = select(revlogTable)
      ..where(
        (data) =>
            data.id.isBiggerOrEqualValue(_begin) &
            data.id.isSmallerOrEqualValue(_end),
      );

    final List<RevlogTableData> logs = await query.get();
    if (logs.isEmpty) return [];

    final Map<String, List<RevlogTableData>> groupedByMonth = {};
    for (int i = 1; i <= 12; i++) {
      final DateTime _now = DateTime.now();
      final DateTime _thisMonth = DateTime(_now.year, i);
      final String _timeName = DateFormat.MMMM('en_US').format(_thisMonth);
      groupedByMonth[_timeName] = [];
    }
    for (var log in logs) {
      final date = DateTime.fromMillisecondsSinceEpoch(log.id);
      final monthKey = DateFormat.MMMM('en_US').format(date);
      groupedByMonth[monthKey]?.add(log);
    }

    final List<DeckAccuracy> monthlyAccuracyList = [];
    groupedByMonth.forEach((timeName, monthLogs) {
      final total = monthLogs.length;
      final correct = monthLogs.where((log) => log.ease == 3).length;
      final accuracy = total > 0 ? (correct * 100 / total).round() : 0;

      monthlyAccuracyList.add(
        DeckAccuracy(timeName: timeName, accuracyNumber: accuracy),
      );
    });

    return monthlyAccuracyList;
  }

  //  ACCURACY MINGGUAN
  Future<List<DeckAccuracy>> getWeeklyAccuracy() async {
    final now = DateTime.now();
    final DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final int _begin = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    ).millisecondsSinceEpoch;
    final int _end = _begin + (7 * 24 * 60 * 60 * 1000);

    final query = select(revlogTable)
      ..where(
        (data) =>
            data.id.isBiggerOrEqualValue(_begin) &
            data.id.isSmallerOrEqualValue(_end),
      );

    final List<RevlogTableData> logs = await query.get();
    if (logs.isEmpty) return [];
    final List<String> dayWeekName = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final Map<String, List<RevlogTableData>> groupedByDay = {};

    for (var day in dayWeekName) {
      groupedByDay[day] = [];
    }
    for (var log in logs) {
      final date = DateTime.fromMillisecondsSinceEpoch(log.id);
      final dayKey = DateFormat.EEEE('en_US').format(date);
      groupedByDay[dayKey]?.add(log);
    }

    final List<DeckAccuracy> weeklyAccuracyList = [];
    groupedByDay.forEach((dayName, dayLogs) {
      final total = dayLogs.length;
      final correct = dayLogs.where((log) => log.ease == 3).length;
      final accuracy = total > 0 ? (correct * 100 / total).round() : 0;

      weeklyAccuracyList.add(
        DeckAccuracy(timeName: dayName, accuracyNumber: accuracy),
      );
    });

    return weeklyAccuracyList;
  }

  DeckTimeConsume _processStats(String timeName, List<RevlogTableData> data) {
    if (data.isEmpty) {
      return DeckTimeConsume(timeName: timeName, avgTime: 0, totalTime: 0);
    }
    final int totalTime = data.fold(0, (sum, log) => sum + log.time);
    final int avgTime = (totalTime / data.length).round();
    return DeckTimeConsume(
      timeName: timeName,
      avgTime: avgTime,
      totalTime: totalTime,
    );
  }

  Future<DeckTimeConsume> getThisMonthTimeConsume() async {
    final DateTime _now = DateTime.now();
    final int _begin = getStartOfMonthEpoch(time: _now);
    final int _end = getStartOfNextMonthEpoch(time: _now);

    final totalTime = revlogTable.time.sum();
    final totalCards = revlogTable.id.count();

    final query = selectOnly(revlogTable)
      ..addColumns([totalTime, totalCards])
      ..where(
        revlogTable.id.isBiggerOrEqualValue(_begin) &
            revlogTable.id.isSmallerOrEqualValue(_end),
      );

    final result = await query.getSingleOrNull();
    final int sumTime = result?.read(totalTime) ?? 0;
    final int count = result?.read(totalCards) ?? 0;
    final int avg = count > 0 ? (sumTime / count).round() : 0;

    return DeckTimeConsume(
      timeName: DateFormat.MMMM('en_US').format(_now),
      avgTime: avg,
      totalTime: sumTime,
    );
  }

  Future<DeckTimeConsume> getPreviousMonthTimeConsume() async {
    final DateTime _now = DateTime.now();
    final DateTime _lastMonth = DateTime(_now.year, _now.month - 1);
    final int _begin = getStartOfPreviousMonthEpoch(time: _now);
    final int _end = getStartOfMonthEpoch(time: _now);

    final totalTime = revlogTable.time.sum();
    final totalCards = revlogTable.id.count();

    final query = selectOnly(revlogTable)
      ..addColumns([totalTime, totalCards])
      ..where(
        revlogTable.id.isBiggerOrEqualValue(_begin) &
            revlogTable.id.isSmallerOrEqualValue(_end),
      );

    final result = await query.getSingleOrNull();
    final int sumTime = result?.read(totalTime) ?? 0;
    final int count = result?.read(totalCards) ?? 0;
    final int avg = count > 0 ? (sumTime / count).round() : 0;

    return DeckTimeConsume(
      timeName: DateFormat.MMMM('en_US').format(_lastMonth),
      avgTime: avg,
      totalTime: sumTime,
    );
  }

  Future<List<DeckTimeConsume>> getMonthlyTimeConsumeList() async {
    final int currentYear = DateTime.now().year;
    final int _begin = DateTime(currentYear, 1, 1).millisecondsSinceEpoch;
    final int _end = DateTime(currentYear + 1, 1, 1).millisecondsSinceEpoch;

    final query = select(revlogTable)
      ..where(
        (data) =>
            data.id.isBiggerOrEqualValue(_begin) &
            data.id.isSmallerOrEqualValue(_end),
      );

    final List<RevlogTableData> logs = await query.get();
    if (logs.isEmpty) return [];

    final Map<String, List<RevlogTableData>> groupedByMonth =
        getMonthlyObject<RevlogTableData>(currentYear);

    for (var log in logs) {
      final date = DateTime.fromMillisecondsSinceEpoch(log.id);
      final monthKey = DateFormat.MMMM('en_US').format(date);
      groupedByMonth[monthKey]?.add(log);
    }

    return groupedByMonth.entries
        .map((entry) => _processStats(entry.key, entry.value))
        .toList();
  }

  Future<List<DeckTimeConsume>> getWeeklyTimeConsumeList() async {
    final now = DateTime.now();
    final DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final int _begin = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    ).millisecondsSinceEpoch;
    final int _end = _begin + (7 * 24 * 60 * 60 * 1000);

    final query = select(revlogTable)
      ..where(
        (data) =>
            data.id.isBiggerOrEqualValue(_begin) &
            data.id.isSmallerOrEqualValue(_end),
      );

    final List<RevlogTableData> logs = await query.get();
    if (logs.isEmpty) return [];

    final Map<String, List<RevlogTableData>> groupedByDay =
        getWeeklyObject<RevlogTableData>();
    for (var log in logs) {
      final date = DateTime.fromMillisecondsSinceEpoch(log.id);
      final dayKey = DateFormat.EEEE('en_US').format(date);

      groupedByDay[dayKey]?.add(log);
    }

    return groupedByDay.entries
        .map((entry) => _processStats(entry.key, entry.value))
        .toList();
  }

  Future<List<DeckTimeConsume>> getDailyTimeConsumeList() async {
    final int currentYear = DateTime.now().year;
    final int _begin = DateTime(currentYear, 1, 1).millisecondsSinceEpoch;
    final int _end = DateTime(currentYear + 1, 1, 1).millisecondsSinceEpoch;

    final query = select(revlogTable)
      ..where(
        (data) =>
            data.id.isBiggerOrEqualValue(_begin) &
            data.id.isSmallerOrEqualValue(_end),
      );

    final List<RevlogTableData> logs = await query.get();
    if (logs.isEmpty) return [];

    final Map<int, List<RevlogTableData>> groupedByDate =
        getDailyObject<RevlogTableData>();

    for (var log in logs) {
      final date = DateTime.fromMillisecondsSinceEpoch(log.id);
      final dateKey = date.day;
      groupedByDate[dateKey]?.add(log);
    }

    return groupedByDate.entries
        .map((entry) => _processStats(entry.key.toString(), entry.value))
        .toList();
  }

  Future<List<DeckAccuracy>> getDailyAccuracyList() async {
    final now = DateTime.now();
    final int _begin = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
    final int _end = DateTime(now.year, now.month + 1, 1).millisecondsSinceEpoch;

    final query = select(revlogTable)
      ..where(
        (data) =>
            data.id.isBiggerOrEqualValue(_begin) &
            data.id.isSmallerOrEqualValue(_end),
      );

    final List<RevlogTableData> logs = await query.get();
    if (logs.isEmpty) return [];

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final Map<int, List<RevlogTableData>> groupedByDate = {};
    for (int i = 1; i <= daysInMonth; i++) {
      groupedByDate[i] = [];
    }

    for (var log in logs) {
      final date = DateTime.fromMillisecondsSinceEpoch(log.id);
      final dateKey = date.day;
      groupedByDate[dateKey]?.add(log);
    }

    return groupedByDate.entries.map((entry) {
      final dayLogs = entry.value;
      final total = dayLogs.length;
      final correct = dayLogs.where((log) => log.ease == 3).length;
      final accuracy = total > 0 ? (correct * 100 / total).round() : 0;
      return DeckAccuracy(
        timeName: entry.key.toString(),
        accuracyNumber: accuracy,
      );
    }).toList();
  }

  Future<List<CardsDetailEntity>> getTimeConsumeTopCards({
    required int begin,
    required int end,
    required OrderEnums orderBy,
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
