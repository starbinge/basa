import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/group_by_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/order_enums.dart';
import 'package:basa_app_project/features/cards/data/dao/accuracy_dao/accuracy_dao.dart';
import 'package:flutter_test/flutter_test.dart';

import 'db_test_helper.dart';

void main() {
  late ExternalDatabase db;
  late AccuracyDao accuracyDao;

  setUp(() async {
    db = await createTestDatabase();
    accuracyDao = db.accuracyDao;
  });

  tearDown(() async {
    await db.close();
  });

  group('AccuracyDao', () {
    test('getAverageNumber computes correct percentage', () async {
      final now = DateTime.now();
      final begin = now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
      final end = now.add(const Duration(days: 1)).millisecondsSinceEpoch;

      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch,
              cid: 1,
              ease: 3,
            ),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch + 1,
              cid: 2,
              ease: 1,
            ),
          );

      final average = await accuracyDao.getAverageNumber(
        begin: begin,
        end: end,
      );

      expect(average, 50);
    });

    test('getAverageNumber returns zero when there is no data', () async {
      final average = await accuracyDao.getAverageNumber(begin: 0, end: 1);

      expect(average, 0);
    });

    test('getReviewedCardsCount counts distinct reviewed cards', () async {
      final now = DateTime.now();
      final begin = now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
      final end = now.add(const Duration(days: 1)).millisecondsSinceEpoch;

      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch,
              cid: 1,
              ease: 3,
            ),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch + 1,
              cid: 1,
              ease: 1,
            ),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch + 2,
              cid: 2,
              ease: 3,
            ),
          );

      final count = await accuracyDao.getReviewedCardsCount(
        begin: begin,
        end: end,
      );

      expect(count, 2);
    });

    test('getTotalTimeByTimeRange sums review time', () async {
      final now = DateTime.now();
      final begin = now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
      final end = now.add(const Duration(days: 1)).millisecondsSinceEpoch;

      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(id: now.millisecondsSinceEpoch, cid: 1, time: 1500),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch + 1,
              cid: 2,
              time: 2500,
            ),
          );

      final total = await accuracyDao.getTotalTimeByTimeRange(
        begin: begin,
        end: end,
      );

      expect(total.seconds, 4);
    });

    test('getMostInaccurateCards only returns wrong (ease 1) cards', () async {
      await insertNoteAndCard(db, cardId: 1, noteId: 1, flds: 'dog\u001fanjing');
      await insertNoteAndCard(db, cardId: 2, noteId: 2, flds: 'cat\u001fkucing');
      await insertNoteAndCard(db, cardId: 3, noteId: 3, flds: 'bird\u001fburung');

      final now = DateTime.now();
      final begin = now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
      final end = now.add(const Duration(days: 1)).millisecondsSinceEpoch;

      // Card 1 is answered wrong twice, card 2 once, card 3 is never wrong.
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(id: now.millisecondsSinceEpoch, cid: 1, ease: 1),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch + 1,
              cid: 1,
              ease: 1,
            ),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch + 2,
              cid: 2,
              ease: 1,
            ),
          );
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch + 3,
              cid: 3,
              ease: 3,
            ),
          );

      final desc = await accuracyDao.getMostInaccurateCards(
        begin: begin,
        end: end,
        orderBy: OrderEnums.desc,
      );

      expect(desc, hasLength(2));
      expect(desc.map((c) => c.id).toList(), containsAll([1, 2]));
      expect(desc.map((c) => c.id), isNot(contains(3)));

      final asc = await accuracyDao.getMostInaccurateCards(
        begin: begin,
        end: end,
        orderBy: OrderEnums.asc,
      );

      // Card 1 has two wrong reviews, card 2 has one: desc puts the most
      // inaccurate card first, asc puts it last.
      expect(desc.first.id, 1);
      expect(asc.first.id, 2);
    });

    test('getAccuracyData emits current month reviews', () async {
      final now = DateTime.now();
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(
              id: now.millisecondsSinceEpoch,
              cid: 1,
              ease: 3,
            ),
          );

      final models = await accuracyDao
          .getAccuracyData(timeRange: GroupedTimeEnum.thisMonth)
          .first;

      expect(models, isNotEmpty);
      expect(models.any((m) => m.ease == 3), isTrue);
    });
  });
}
