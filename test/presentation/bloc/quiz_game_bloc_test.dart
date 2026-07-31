import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/quiz_game_enum.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/data/repositories/flashcard_repo_impl.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/quiz_game_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/quiz_game/quiz_game_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/dao/db_test_helper.dart';

CardsDetailEntity buildCard({
  required int id,
  int queue = 100,
  int reps = 0,
  int factor = 250,
  int left = 10,
  int flags = 0,
  String? def,
  String? trans,
}) {
  return CardsDetailEntity(
    id: id,
    noteId: id,
    queue: queue,
    reps: reps,
    odue: 0,
    ivl: 0,
    left: left,
    defaultLanguage: def ?? 'word$id',
    translatedLanguage: trans ?? 'translation$id',
    descriptions: const [],
    audioPath: const [],
    factor: factor,
    flags: flags,
  );
}

QuizGameEntity buildQuizGameEntity({required int id}) {
  return QuizGameEntity(
    questionType: QuizGameEnum.translateLanguage,
    question: 'word$id',
    correctAnswer: 'translation$id',
    options: const ['a', 'b', 'c', 'd'],
    cid: id,
  );
}

void main() {
  group('QuizGameBloc - GeneratingQuizGameQuestions', () {
    late ExternalDatabase db;
    late CardsDao cardsDao;

    setUp(() async {
      db = await createTestDatabase();
      cardsDao = db.cardsDao;
    });

    tearDown(() async {
      await db.close();
    });

    blocTest<QuizGameBloc, QuizGameState>(
      'emits loading then finish with up to 10 sorted cards',
      build: () => QuizGameBloc(
        cardsDao: cardsDao,
        flashCardRepo: FlashcardRepoImpl(),
      ),
      act: (bloc) {
        final cards = List.generate(
          12,
          (i) => buildCard(id: i + 1, queue: i + 1),
        );
        bloc.add(GeneratingQuizGameQuestions(listCards: cards));
      },
      expect: () => [
        isA<QuizGameIsLoading>(),
        isA<QuizGameIsFinish>()
            .having((s) => s.cards.length, 'cards length', 10)
            .having(
              (s) => s.cards.map((c) => c.cid).toList(),
              'keeps ascending queue order',
              [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            ),
      ],
    );

    blocTest<QuizGameBloc, QuizGameState>(
      'wraps startIndex to zero when it exceeds the card list',
      build: () => QuizGameBloc(
        cardsDao: cardsDao,
        flashCardRepo: FlashcardRepoImpl(),
      ),
      act: (bloc) {
        final cards = List.generate(
          5,
          (i) => buildCard(id: i + 1, queue: i),
        );
        bloc.add(
          GeneratingQuizGameQuestions(listCards: cards, startIndex: 99),
        );
      },
      expect: () => [
        isA<QuizGameIsLoading>(),
        isA<QuizGameIsFinish>().having((s) => s.cards.length, 'cards length', 5),
      ],
    );

    blocTest<QuizGameBloc, QuizGameState>(
      'uses the default language as the first question',
      build: () => QuizGameBloc(
        cardsDao: cardsDao,
        flashCardRepo: FlashcardRepoImpl(),
      ),
      act: (bloc) {
        final cards = List.generate(
          6,
          (i) => buildCard(id: i + 1, queue: i, def: 'apple$i', trans: 'apel$i'),
        );
        bloc.add(GeneratingQuizGameQuestions(listCards: cards));
      },
      expect: () => [
        isA<QuizGameIsLoading>(),
        isA<QuizGameIsFinish>().having(
          (s) => s.cards.first,
          'first question',
          isA<QuizGameEntity>()
              .having((q) => q.questionType, 'type', QuizGameEnum.translateLanguage)
              .having((q) => q.question, 'question', 'apple0')
              .having((q) => q.correctAnswer, 'answer', 'apel0'),
        ),
      ],
    );
  });

  group('QuizGameBloc - AnsweringQuestion', () {
    late ExternalDatabase db;
    late CardsDao cardsDao;

    setUp(() async {
      db = await createTestDatabase();
      cardsDao = db.cardsDao;
      await insertNoteAndCard(
        db,
        cardId: 1,
        noteId: 1,
        flds: 'apple\u001fapel',
        queue: 100,
        reps: 0,
        factor: 250,
        left: 10,
      );
    });

    tearDown(() async {
      await db.close();
    });

    blocTest<QuizGameBloc, QuizGameState>(
      'increments the counters and writes the answer to the database',
      build: () => QuizGameBloc(
        cardsDao: cardsDao,
        flashCardRepo: FlashcardRepoImpl(),
      ),
      seed: () => QuizGameIsFinish(
        cards: [buildQuizGameEntity(id: 1)],
        totalQuestion: 1,
        activeQuestion: 0,
        answeredQuestion: 0,
      ),
      act: (bloc) => bloc.add(
        AnsweringQuestion(
          answer: FlashcardAnswerEnum.correct,
          selectedCard: buildCard(id: 1, queue: 100),
          timeMs: 1000,
          isCorrect: true,
        ),
      ),
      expect: () => [
        isA<QuizGameIsFinish>()
            .having((s) => s.activeQuestion, 'activeQuestion', 1)
            .having((s) => s.answeredQuestion, 'answeredQuestion', 1),
      ],
      verify: (bloc) async {
        final card = await cardsDao.getCardById(cardId: 1);
        expect(card, isNotNull);
        expect(card!.reps, 1);
        expect(card.left, 9);
        expect(card.flags, 1);

        final revlogs = await db.select(db.revlogTable).get();
        expect(revlogs, hasLength(1));
        expect(revlogs.first.cid, 1);
        expect(revlogs.first.ease, 3);
        expect(revlogs.first.time, 1000);
      },
    );

    blocTest<QuizGameBloc, QuizGameState>(
      'does not count a wrong answer as answered',
      build: () => QuizGameBloc(
        cardsDao: cardsDao,
        flashCardRepo: FlashcardRepoImpl(),
      ),
      seed: () => QuizGameIsFinish(
        cards: [buildQuizGameEntity(id: 1)],
        totalQuestion: 1,
        activeQuestion: 0,
        answeredQuestion: 0,
      ),
      act: (bloc) => bloc.add(
        AnsweringQuestion(
          answer: FlashcardAnswerEnum.wrong,
          selectedCard: buildCard(id: 1, queue: 100),
          timeMs: 9000,
          isCorrect: false,
        ),
      ),
      expect: () => [
        isA<QuizGameIsFinish>()
            .having((s) => s.activeQuestion, 'activeQuestion', 1)
            .having((s) => s.answeredQuestion, 'answeredQuestion', 0)
            .having((s) => s.cards, 'cards preserved', hasLength(1)),
      ],
      verify: (bloc) async {
        final card = await cardsDao.getCardById(cardId: 1);
        expect(card!.flags, 0);
      },
    );
  });
}
