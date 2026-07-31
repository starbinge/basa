import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/data/external_database/external_database_accessor.dart';
import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/wrong_answer_bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;

import '../../../constants/enums/flashcard_answer_enum.dart';
import '../../bloc/quiz_game/quiz_game_bloc.dart';

class OptionButton extends StatefulWidget {
  const OptionButton({
    super.key,
    required this.option,
    required this.correctAnswer,
    required this.onTap,
    required this.indexOption,
    required this.indexCorrectOption,
    required this.selectedIndex,
    required this.timeSpentPerQuestion,
    required this.selectedCard,
    required this.audioPlayer,
  });

  final String option;
  final String correctAnswer;
  final VoidCallback onTap;
  final int indexOption;
  final int indexCorrectOption;
  final int selectedIndex;
  final int timeSpentPerQuestion;
  final CardsDetailEntity selectedCard;
  final AudioPlayer audioPlayer;

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  @override
  Widget build(BuildContext context) {
    final bool hasAnswered = widget.selectedIndex != -1;

    Color backgroundColor = AppColors.inversePrimary;
    Color textColor = AppColors.primaryDark;
    double padding = 10;

    if (hasAnswered) {
      if (widget.indexOption == widget.indexCorrectOption) {
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;

        if (widget.indexOption == widget.selectedIndex) {
          padding = 20;
        } else {
          padding = 10;
        }
      } else if (widget.indexOption == widget.selectedIndex) {
        backgroundColor = AppColors.errorContainer;
        textColor = AppColors.error;
        padding = 20;
      }
    }

    return GestureDetector(
      onTap: hasAnswered
          ? null
          : () {
              widget.onTap();
              if (widget.indexOption == widget.indexCorrectOption) {
                widget.audioPlayer.play(
                  AssetSource(
                    "sfx/shidenbeatsmusic-sound-effect-twinklesparkle-115095.mp3",
                  ),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  context.read<QuizGameBloc>()..add(
                    AnsweringQuestion(
                      answer: FlashcardAnswerEnum.correct,
                      selectedCard: widget.selectedCard,
                      timeMs: widget.timeSpentPerQuestion,
                      isCorrect: true,
                    ),
                  );
                });
              } else {
                final bloc = context.read<QuizGameBloc>();
                widget.audioPlayer.play(
                  AssetSource("sfx/freesound_community-wrong-47985.mp3"),
                );

                showBottomBar(audioPlayer: widget.audioPlayer, bloc: bloc);
              }
            },
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: padding),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        width: double.infinity,
        curve: Curves.bounceOut,
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: Text(
            widget.option,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void showBottomBar({
    required AudioPlayer audioPlayer,
    required QuizGameBloc bloc,
  }) async {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return WrongAnswerBottombar(
          selectedCard: widget.selectedCard,
          audioPlayer: audioPlayer,
          playButtonPressed: () {
            final audioPath = widget.selectedCard.audioPath.isNotEmpty
                ? widget.selectedCard.audioPath.first
                : null;
            if (audioPath != null) {
              audioPlayer.play(
                DeviceFileSource(
                  path
                      .join(
                        RepositoryProvider.of<ExternalDatabaseAccessor>(
                          context,
                        ).filePath!,
                        audioPath,
                      )
                      .replaceAll('\\', '/'),
                ),
              );
            }
          },
          pauseButtonPressed: () {
            audioPlayer.pause();
          },
          textButtonPressed: () {
            bloc..add(
              AnsweringQuestion(
                answer: FlashcardAnswerEnum.wrong,
                selectedCard: widget.selectedCard,
                timeMs: widget.timeSpentPerQuestion,
                isCorrect: false,
              ),
            );
            Navigator.pop(context);
            final blocState = bloc.state;
            if (blocState is QuizGameIsFinish) {
              final isDone =
                  (blocState.activeQuestion ?? 0) >= blocState.cards.length;
              if (isDone) {
                context.push(
                  '/stats-quiz-game',
                  extra: (
                    totalAnswered: blocState.answeredQuestion,
                    isLate: false,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
