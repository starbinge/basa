import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/features/cards/domain/entities/quiz_game_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/cards_detail_entity.dart';
import '../../bloc/quiz_game/quiz_game_bloc.dart';
import 'button_option.dart';

class AnswerOptionSection extends StatefulWidget {
  const AnswerOptionSection({
    super.key,
    required this.listCards,
    required this.filePath,
    required this.audioPlayer,
  });

  final List<CardsDetailEntity> listCards;
  final File filePath;
  final AudioPlayer audioPlayer;

  @override
  State<AnswerOptionSection> createState() => _AnswerOptionSectionState();
}

class _AnswerOptionSectionState extends State<AnswerOptionSection> {
  int timeSpentPerQuestion = 0;
  Stopwatch _stopwatch = Stopwatch();
  int selectedIndex = -1;
  bool _showWrongBottomBar = false;
  CardsDetailEntity? _wrongCard;

  @override
  void initState() {
    _stopwatch.start();
    super.initState();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizGameBloc, QuizGameState>(
      listenWhen: (before, after) {
        return after is QuizGameIsFinish;
      },
      listener: (context, state) {
        if (state is QuizGameIsFinish) {
          setState(() {
            selectedIndex = -1;
            timeSpentPerQuestion = 0;
          });
          _stopwatch
            ..reset()
            ..start();
          final isDone = (state.activeQuestion ?? 0) >= state.cards.length;
          if (isDone && !_showWrongBottomBar) {
            context.push(
              '/stats-quiz-game',
              extra: (totalAnswered: state.answeredQuestion, isLate: false),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is QuizGameIsFinish) {
          int activeQuestion = state.activeQuestion ?? 0;
          if (activeQuestion >= state.cards.length) {
            return const SizedBox.shrink();
          }
          QuizGameEntity card = state.cards[activeQuestion];
          int correctAnswerIndex = card.options.indexWhere(
            (option) => option == card.correctAnswer,
          );
          return Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      topLeft: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "What does this mean?",
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Column(
                          key: ValueKey<int>(state.activeQuestion ?? 0),
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(card.options.length, (
                            itemIndex,
                          ) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child:
                                    OptionButton(
                                          option: card.options[itemIndex],
                                          correctAnswer: card.correctAnswer,
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = itemIndex;
                                            });

                                            onUserAnswered();
                                          },
                                          indexOption: itemIndex,
                                          indexCorrectOption:
                                              correctAnswerIndex,
                                          selectedIndex: selectedIndex,
                                          timeSpentPerQuestion:
                                              timeSpentPerQuestion,
                                          selectedCard: widget.listCards
                                              .where(
                                                (data) =>
                                                    data.id ==
                                                    state
                                                        .cards[activeQuestion]
                                                        .cid,
                                              )
                                              .first,
                                          audioPlayer: widget.audioPlayer,
                                        )
                                        .animate(
                                          delay: Duration(
                                            milliseconds: 80 * itemIndex,
                                          ),
                                        )
                                        .scale(
                                          curve: Curves.bounceOut,
                                          duration: const Duration(
                                            milliseconds: 600,
                                          ),
                                        ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ).animate().slideY(
                  duration: const Duration(milliseconds: 300),
                  begin: 1,
                  end: 0,
                  curve: Curves.fastLinearToSlowEaseIn,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void onUserAnswered() {
    _stopwatch.stop();

    int millisecondsSpent = _stopwatch.elapsed.inMilliseconds;
    timeSpentPerQuestion = millisecondsSpent;

    _stopwatch.reset();
    _stopwatch.start();
  }
}
