import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/core/widgets/timer_container.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/quiz_game/quiz_game_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/answer_options_section.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/progress_bar_indicator.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/question_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizGamePage extends StatefulWidget {
  const QuizGamePage({
    super.key,
    required this.listCards,
    required this.generatedDeckDao,
    this.startIndex = 0,
  });

  final List<CardsDetailEntity> listCards;
  final GeneratedDeckDao generatedDeckDao;
  final int startIndex;

  @override
  State<QuizGamePage> createState() => _QuizGamePageState();
}

class _QuizGamePageState extends State<QuizGamePage> {
  int timeLeft = 300;
  int answeredQuestion = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          QuizGameBloc(generatedDeckDao: widget.generatedDeckDao)
            ..add(
              GeneratingQuizGameQuestions(
                listCards: widget.listCards,
                startIndex: widget.startIndex,
              ),
            ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 130,
          flexibleSpace: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Quiz Time",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Center(
                    child: TimerContainer(
                      time: timeLeft,
                      totalAnswered: answeredQuestion,
                    ),
                  ),
                  const ProgressBarIndicator(),
                ],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: BlocConsumer<QuizGameBloc, QuizGameState>(
            listener: (BuildContext context, QuizGameState state) {
              if (state is QuizGameIsFinish) {
                setState(() {
                  answeredQuestion = state.answeredQuestion ?? 0;
                });
              }
            },
            builder: (context, state) {
              if (state is QuizGameInitial || state is QuizGameIsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is QuizGameIsError) {
                return ErrorPage(message: state.errorMessage);
              }
              if (state is QuizGameIsFinish) {
                if ((state.activeQuestion ?? 0) >= state.cards.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    QuestionSection(
                      activeQuestion: state.activeQuestion ?? 0,
                      question: state.cards[state.activeQuestion ?? 0].question,
                    ),

                    AnswerOptionSection(
                      listCards: widget.listCards,
                    ),
                  ],
                );
              }
              return const ErrorPage(message: "Something wrong is unknown");
            },
          ),
        ),
      ),
    );
  }
}
