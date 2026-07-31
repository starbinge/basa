import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/dao/time_consume_dao/time_consume_dao.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'db_test_helper.dart';

void main() {
  late ExternalDatabase db;
  late TimeConsumeDao timeConsumeDao;

  setUpAll(() async {
    await initializeDateFormatting('en_US');
  });

  setUp(() async {
    db = await createTestDatabase();
    timeConsumeDao = db.timeConsumeDao;
  });

  tearDown(() async {
    await db.close();
  });

  group('TimeConsumeDao', () {
    test('getReviewedCardsCount counts distinct reviewed cards', () async {
      final now = DateTime.now();
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch,
              cid: 1,
              time: 1000,
            ),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.add(const Duration(days: 1)).millisecondsSinceEpoch,
              cid: 2,
              time: 2000,
            ),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
              cid: 3,
              time: 3000,
            ),
          );

      final count = await timeConsumeDao.getReviewedCardsCount(
        begin: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        end: now.add(const Duration(days: 1)).millisecondsSinceEpoch,
      );

      expect(count, 2);
    });

    test('getAverageTimeByTimeRange averages the review time', () async {
      final now = DateTime.now();
      final begin = now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
      final end = now.add(const Duration(days: 1)).millisecondsSinceEpoch;

      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch,
              cid: 1,
              time: 1000,
            ),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch + 1,
              cid: 2,
              time: 3000,
            ),
          );

      final avg = await timeConsumeDao.getAverageTimeByTimeRange(
        begin: begin,
        end: end,
      );

      expect(avg.hour, 0);
      expect(avg.minute, 0);
      expect(avg.seconds, 2);
      expect(avg.formatted, '2s');
    });

    test('getAverageTimeByTimeRange returns zero when there is no data', () async {
      final avg = await timeConsumeDao.getAverageTimeByTimeRange(
        begin: 0,
        end: DateTime.now().millisecondsSinceEpoch,
      );

      expect(avg.seconds, 0);
    });

    test('getTotalTimeByTimeRange sums the review time', () async {
      final now = DateTime.now();
      final begin = now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
      final end = now.add(const Duration(days: 1)).millisecondsSinceEpoch;

      for (final time in [1000, 2000, 3000]) {
        await db.into(db.revlogTable).insert(
              buildRevlogCompanion(
                id: now.millisecondsSinceEpoch + time,
                cid: 1,
                time: time,
              ),
            );
      }

      final total = await timeConsumeDao.getTotalTimeByTimeRange(
        begin: begin,
        end: end,
      );

      expect(total.seconds, 6);
    });

    test('getThisWeekStreakData buckets today review time under today', () async {
      final now = DateTime.now();
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch,
              cid: 1,
              time: 2000,
            ),
          );

      final result = await timeConsumeDao.getThisWeekStreakData();

      final todayLabel = DateFormatEEEE();
      final todayBucket = result.firstWhere(
        (e) => e.timeLabel == todayLabel,
        orElse: () => TimeConsumeEntity(
          timeLabel: todayLabel,
          avgTime: TimeUnit.fromMilliSeconds(0),
          totalTime: TimeUnit.fromMilliSeconds(0),
        ),
      );

      expect(todayBucket.totalTime.seconds, 2);
      expect(todayBucket.avgTime.seconds, 2);
    });

    test('getTimeConsumeTopCards orders by total time descending', () async {
      await insertNoteAndCard(db, cardId: 1, noteId: 1, flds: 'dog\u001fanjing');
      await insertNoteAndCard(db, cardId: 2, noteId: 2, flds: 'cat\u001fkucing');

      final now = DateTime.now();
      final begin = now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
      final end = now.add(const Duration(days: 1)).millisecondsSinceEpoch;

      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch,
              cid: 1,
              time: 1000,
            ),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch + 1,
              cid: 1,
              time: 2000,
            ),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch + 2,
              cid: 2,
              time: 4000,
            ),
          );

      final desc = await timeConsumeDao.getTimeConsumeTopCards(
        begin: begin,
        end: end,
        orderBy: OrderEnums.desc,
        limit: 2,
      );

      expect(desc, hasLength(2));
      expect(desc.first.card.id, 2);
      expect(desc.first.timeSpent.seconds, 4);

      final asc = await timeConsumeDao.getTimeConsumeTopCards(
        begin: begin,
        end: end,
        orderBy: OrderEnums.asc,
        limit: 2,
      );

      expect(asc.first.card.id, 1);
    });

    test('getGroupedTimeConsume emits current month reviews', () async {
      final now = DateTime.now();
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch,
              cid: 1,
              time: 5000,
            ),
          );

      final models = await timeConsumeDao
          .getGroupedTimeConsume(timeRange: GroupedTimeEnum.daily)
          .first;

      expect(models, isNotEmpty);
      expect(models.any((m) => m.timeSpent == 5000), isTrue);
    });
  });
}

String DateFormatEEEE() {
  final now = DateTime.now();
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return names[now.weekday - 1];
}
