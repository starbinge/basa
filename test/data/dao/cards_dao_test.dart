import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao/cards_dao.dart';
import 'package:flutter_test/flutter_test.dart';

import 'db_test_helper.dart';

void main() {
  late ExternalDatabase db;
  late CardsDao cardsDao;

  setUp(() async {
    db = await createTestDatabase();
    cardsDao = db.cardsDao;
  });

  tearDown(() async {
    await db.close();
  });

  group('CardsDao', () {
    test('getCards returns cards ordered by queue ascending', () async {
      await insertNoteAndCard(
        db,
        cardId: 1,
        noteId: 1,
        flds: 'apple\u001fapel',
        queue: 3,
      );
      await insertNoteAndCard(
        db,
        cardId: 2,
        noteId: 2,
        flds: 'banana\u001fpisang',
        queue: 1,
      );
      await insertNoteAndCard(
        db,
        cardId: 3,
        noteId: 3,
        flds: 'cherry\u001fceri',
        queue: 2,
      );

      final cards = await cardsDao.getCards(50);

      expect(cards, hasLength(3));
      expect(cards.map((c) => c.queue).toList(), [1, 2, 3]);
      expect(cards.first.defaultLanguage, 'banana');
    });

    test('getCards respects limit and offset', () async {
      for (var i = 1; i <= 5; i++) {
        await insertNoteAndCard(
          db,
          cardId: i,
          noteId: i,
          flds: 'word$i\u001fterjemahan$i',
          queue: i,
        );
      }

      final firstPage = await cardsDao.getCards(2);
      final secondPage = await cardsDao.getCards(2, offset: 2);

      expect(firstPage, hasLength(2));
      expect(secondPage, hasLength(2));
      expect(secondPage.first.defaultLanguage, 'word3');
    });

    test('getCardById returns the matching card', () async {
      await insertNoteAndCard(
        db,
        cardId: 42,
        noteId: 7,
        flds: 'dog\u001fanjing',
      );

      final card = await cardsDao.getCardById(cardId: 42);

      expect(card, isNotNull);
      expect(card!.defaultLanguage, 'dog');
      expect(card.translatedLanguage, 'anjing');
      expect(card.noteId, 7);
    });

    test('getCardById returns null when the card does not exist', () async {
      final card = await cardsDao.getCardById(cardId: 999);

      expect(card, isNull);
    });

    test('updateCards updates the given fields', () async {
      await insertNoteAndCard(
        db,
        cardId: 1,
        noteId: 1,
        flds: 'cat\u001fkucing',
      );

      final updated = await cardsDao.updateCards(
        updatedCardValue: buildCardCompanion(
          id: 1,
          nid: 1,
          queue: 120000,
          odue: 20,
          factor: 215,
          left: 9,
          reps: 1,
          flags: 1,
        ),
      );

      expect(updated, 1);
      final card = await cardsDao.getCardById(cardId: 1);
      expect(card!.queue, 120000);
      expect(card.odue, 20);
      expect(card.factor, 215);
      expect(card.left, 9);
      expect(card.reps, 1);
      expect(card.flags, 1);
    });

    test('insertRevlog inserts a row', () async {
      await db.into(db.revlogTable).insert(
            buildRevlogCompanion(id: 1234, cid: 1, ease: 3, time: 2500),
          );

      final rows = await db.select(db.revlogTable).get();

      expect(rows, hasLength(1));
      expect(rows.first.id, 1234);
      expect(rows.first.cid, 1);
      expect(rows.first.ease, 3);
      expect(rows.first.time, 2500);
    });

    test('searchCard emits matching cards via stream', () async {
      await insertNoteAndCard(
        db,
        cardId: 1,
        noteId: 1,
        flds: 'apple\u001fapel',
      );
      await insertNoteAndCard(
        db,
        cardId: 2,
        noteId: 2,
        flds: 'banana\u001fpisang',
      );

      final results = await cardsDao.searchCard(searchParams: 'banana').first;

      expect(results, hasLength(1));
      expect(results.first.defaultLanguage, 'banana');
    });
  });
}
