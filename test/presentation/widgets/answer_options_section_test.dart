import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/quiz_game/quiz_game_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/answer_options_section.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/button_option.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

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

Future<QuizGameBloc> blocInFinishState(
  GeneratedDeckDao dao,
  List<CardsDetailEntity> cards,
) async {
  final bloc = QuizGameBloc(generatedDeckDao: dao);
  bloc.add(GeneratingQuizGameQuestions(listCards: cards));
  await bloc.stream.firstWhere((s) => s is QuizGameIsFinish);
  return bloc;
}

void main() {
  testWidgets('renders the question and shuffled answer options',
      (tester) async {
    final db = GeneratedDeckDatabase(NativeDatabase.memory());
    final cards = List.generate(4, (i) => buildCard(id: i + 1));
    final bloc = await blocInFinishState(db.generatedDeckDao, cards);
    addTearDown(db.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<QuizGameBloc>.value(
          value: bloc,
          child: Scaffold(
            body: Column(
              children: [
                AnswerOptionSection(listCards: cards),
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
