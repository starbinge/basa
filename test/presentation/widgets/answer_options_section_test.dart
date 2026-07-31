import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/data/external_database/external_database.dart';
import 'package:basa_app_project/features/cards/data/repositories/flashcard_repo_impl.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/quiz_game/quiz_game_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/answer_options_section.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/button_option.dart';
import 'dart:io';

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
  testWidgets('renders the question and shuffled answer options',
      (tester) async {
    final db = ExternalDatabase(NativeDatabase.memory());
    final cards = List.generate(
      4,
      (i) => buildCard(id: i + 1, queue: i + 1),
    );
    final bloc = await blocInFinishState(db, cards);
    addTearDown(db.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<QuizGameBloc>.value(
          value: bloc,
          child: Scaffold(
            body: Column(
              children: [
                AnswerOptionSection(
                  listCards: cards,
                  filePath: File(''),
                  audioPlayer: AudioPlayer(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('What does this mean?'), findsOneWidget);

    final optionButtons = tester
        .widgetList<OptionButton>(find.byType(OptionButton))
        .toList();
    expect(optionButtons.length, 4);

    final optionTexts = optionButtons.map((b) => b.option).toSet();
    expect(optionTexts, contains('translation1'));
    expect(optionTexts, hasLength(4));
  });
}
