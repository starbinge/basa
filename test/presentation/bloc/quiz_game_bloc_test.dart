import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/constants/enums/quiz_game_enum.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/quiz_game_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/quiz_game/quiz_game_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CardsDetailEntity buildCard({
  required int id,
  String? def,
  String? trans,
}) {
  return CardsDetailEntity(
    id: id,
    defaultLanguage: def ?? 'word$id',
    translatedLanguage: trans ?? 'translation$id',
    additionalContext: '',
    pronunciation: '',
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
  late GeneratedDeckDatabase db;

  setUp(() {
    db = GeneratedDeckDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('QuizGameBloc - GeneratingQuizGameQuestions', () {
    blocTest<QuizGameBloc, QuizGameState>(
      'emits loading then finish with up to 10 sorted cards',
      build: () => QuizGameBloc(generatedDeckDao: db.generatedDeckDao),
      act: (bloc) {
        final cards = List.generate(
          12,
          (i) => buildCard(id: i + 1),
        );
        bloc.add(GeneratingQuizGameQuestions(listCards: cards));
      },
      expect: () => [
        isA<QuizGameIsLoading>(),
        isA<QuizGameIsFinish>()
            .having((s) => s.cards.length, 'cards length', 10)
            .having(
              (s) => s.cards.map((c) => c.cid).toList(),
              'keeps ascending id order',
              [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            ),
      ],
    );

    blocTest<QuizGameBloc, QuizGameState>(
      'wraps startIndex to zero when it exceeds the card list',
      build: () => QuizGameBloc(generatedDeckDao: db.generatedDeckDao),
      act: (bloc) {
        final cards = List.generate(
          5,
          (i) => buildCard(id: i + 1),
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
      build: () => QuizGameBloc(generatedDeckDao: db.generatedDeckDao),
      act: (bloc) {
        final cards = List.generate(
          6,
          (i) => buildCard(id: i + 1, def: 'apple$i', trans: 'apel$i'),
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
    late int cardId;

    setUp(() async {
      cardId = await db.generatedDeckDao.insertCard(
        GeneratedCardsTableCompanion.insert(
          defaultLanguage: 'apple',
          translation: 'apel',
          additionalContext: '',
          pronunciation: '',
        ),
      );
    });

    blocTest<QuizGameBloc, QuizGameState>(
      'increments the counters and writes the answer to the database',
      build: () => QuizGameBloc(generatedDeckDao: db.generatedDeckDao),
      seed: () => QuizGameIsFinish(
        cards: [buildQuizGameEntity(id: cardId)],
        totalQuestion: 1,
        activeQuestion: 0,
        answeredQuestion: 0,
      ),
      act: (bloc) => bloc.add(
        AnsweringQuestion(
          answer: FlashcardAnswerEnum.correct,
          selectedCard: buildCard(id: cardId),
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
        final cards = await db.select(db.generatedCardsTable).get();
        expect(cards, hasLength(1));
        expect(cards.first.score, 1);

        final history = await db.select(db.historyTable).get();
        expect(history, hasLength(1));
        expect(history.first.idC, cardId);
        expect(history.first.answer, 1);
        expect(history.first.totalTime, 1000);
      },
    );

    blocTest<QuizGameBloc, QuizGameState>(
      'does not count a wrong answer as answered',
      build: () => QuizGameBloc(generatedDeckDao: db.generatedDeckDao),
      seed: () => QuizGameIsFinish(
        cards: [buildQuizGameEntity(id: cardId)],
        totalQuestion: 1,
        activeQuestion: 0,
        answeredQuestion: 0,
      ),
      act: (bloc) => bloc.add(
        AnsweringQuestion(
          answer: FlashcardAnswerEnum.wrong,
          selectedCard: buildCard(id: cardId),
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
        final cards = await db.select(db.generatedCardsTable).get();
        expect(cards, hasLength(1));
        expect(cards.first.score, 0);

        final history = await db.select(db.historyTable).get();
        expect(history, hasLength(1));
        expect(history.first.answer, 0);
      },
    );
  });
}
