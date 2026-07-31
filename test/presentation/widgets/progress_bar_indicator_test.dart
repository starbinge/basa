import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/data/repositories/flashcard_repo_impl.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/quiz_game/quiz_game_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/progress_bar_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

CardsDetailEntity buildCard({
  required int id,
  int queue = 100,
  String? def,
  String? trans,
}) {
  return CardsDetailEntity(
    id: id,
    noteId: id,
    queue: queue,
    reps: 0,
    odue: 0,
    ivl: 0,
    left: 10,
    defaultLanguage: def ?? 'word$id',
    translatedLanguage: trans ?? 'translation$id',
    descriptions: const [],
    audioPath: const [],
    factor: 250,
    flags: 0,
  );
}

Future<QuizGameBloc> blocInFinishState(
  ExternalDatabase db,
  List<CardsDetailEntity> cards,
) async {
  final bloc = QuizGameBloc(
    cardsDao: db.cardsDao,
    flashCardRepo: FlashcardRepoImpl(),
  );
  bloc.add(GeneratingQuizGameQuestions(listCards: cards));
  await bloc.stream.firstWhere((s) => s is QuizGameIsFinish);
  return bloc;
}

void main() {
  testWidgets('shows zero progress on the initial state', (tester) async {
    final db = ExternalDatabase(NativeDatabase.memory());
    final bloc = QuizGameBloc(
      cardsDao: db.cardsDao,
      flashCardRepo: FlashcardRepoImpl(),
    );
    addTearDown(db.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<QuizGameBloc>.value(
          value: bloc,
          child: const Scaffold(
            body: Center(child: ProgressBarIndicator()),
          ),
        ),
      ),
    );

    final stackFinder = find.byType(Stack);
    final containers = find.descendant(
      of: stackFinder,
      matching: find.byType(Container),
    );
    expect(containers, findsNWidgets(2));

    final outerSize = tester.getSize(containers.at(0));
    final innerSize = tester.getSize(containers.at(1));
    expect(innerSize.width, closeTo(outerSize.width * 0.1, 0.01));
  });

  testWidgets('grows the colored bar as questions are answered',
      (tester) async {
    final db = ExternalDatabase(NativeDatabase.memory());
    final cards = List.generate(
      10,
      (i) => buildCard(id: i + 1, queue: i + 1),
    );
    final bloc = await blocInFinishState(db, cards);
    addTearDown(db.close);

    final selectedCard = cards.first;
    for (var i = 0; i < 4; i++) {
      bloc.add(
        AnsweringQuestion(
          answer: FlashcardAnswerEnum.correct,
          selectedCard: selectedCard,
          timeMs: 1000,
          isCorrect: true,
        ),
      );
      await bloc.stream.firstWhere((s) => s is QuizGameIsFinish);
    }

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<QuizGameBloc>.value(
          value: bloc,
          child: const Scaffold(
            body: Center(child: ProgressBarIndicator()),
          ),
        ),
      ),
    );

    final stackFinder = find.byType(Stack);
    final containers = find.descendant(
      of: stackFinder,
      matching: find.byType(Container),
    );
    final outerSize = tester.getSize(containers.at(0));
    final innerSize = tester.getSize(containers.at(1));

    // activeQuestion = 4 → colored bar is 5/10 of the track.
    expect(innerSize.width, closeTo(outerSize.width * 0.5, 0.01));
  });
}
