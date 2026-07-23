import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:basa_app_project/core/widgets/animated_play_pause_button.dart';
import 'package:basa_app_project/features/cards/constants/enums/flashcard_answer_enum.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/quiz_game_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/flash_card_repo.dart';
import 'package:basa_app_project/features/cards/domain/usecases/format_time_usecase.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/quiz_game/quiz_game_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/button_option.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/quiz_game/wrong_answer_bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:path/path.dart' as path;

class QuizGamePage extends StatefulWidget {
  const QuizGamePage({
    super.key,
    required this.listCards,
    required CardsDao cardsDao,
    required FlashCardRepo flashCardRepo,
    required this.filePath,
    this.startIndex = 0,
  }) : _flashCardRepo = flashCardRepo,
       _cardsDao = cardsDao;
  final List<CardsDetailEntity> listCards;
  final CardsDao _cardsDao;
  final FlashCardRepo _flashCardRepo;
  final File filePath;
  final int startIndex;

  @override
  State<QuizGamePage> createState() => _QuizGamePageState();
}

class _QuizGamePageState extends State<QuizGamePage> {
  int timeLeft = 300;
  int answeredQuestion = 0;
  int activeIndex = 0;
  int timeSpentPerQuestion = 0;
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();
  int selectedIndex = -1;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _stopwatch.start();
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double dynamicMaxWidth = screenWidth * 0.85;

    return Scaffold(
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.inversePrimary.withValues(alpha: 0.3),
                    ),
                    child: Row(
                      spacing: 8,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.alarm_rounded,
                          color: AppColors.primaryDark,
                          size: 18,
                        ),
                        Text(
                          FormatTimeUseCase().timeDividerFromSeconds(
                            durations: timeLeft.toString(),
                          ),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: AppColors.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 8,
                      width: dynamicMaxWidth,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 8,
                      width: (dynamicMaxWidth * (activeIndex + 1) / 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => QuizGameBloc(
            cardsDao: widget._cardsDao,
            flashCardRepo: widget._flashCardRepo,
          )..add(GeneratingQuizGameQuestions(
              listCards: widget.listCards,
              startIndex: widget.startIndex,
            )),
          child: BlocBuilder<QuizGameBloc, QuizGameState>(
            builder: (context, state) {
              if (state is QuizGameInitial || state is QuizGameIsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is QuizGameIsError) {
                return ErrorPage(message: state.errorMessage);
              }
              if (state is QuizGameIsFinish) {
                QuizGameEntity data = state.cards[activeIndex];
                int correctAnswerIndex = data.options.indexWhere(
                  (option) => option == data.correctAnswer,
                );

                double cookieSize = (screenWidth * 0.65).clamp(200.0, 260.0);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      key: ValueKey<int>(activeIndex),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      child: SizedBox(
                        width: cookieSize,
                        height: cookieSize,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            M3EShape.c9SidedCookie(
                                  width: cookieSize,
                                  height: cookieSize,
                                  color: AppColors.inversePrimary.withValues(
                                    alpha: 0.2,
                                  ),
                                )
                                .animate(
                                  onComplete: (controller) =>
                                      controller.repeat(),
                                )
                                .rotate(
                                  curve: Curves.linear,
                                  duration: const Duration(seconds: 5),
                                ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child:
                                      data.question.contains(".mp3") ||
                                          data.question.contains(".wav")
                                      ? AnimatedPlayPauseButton(
                                          isPlaying: _isPlaying,
                                          onPressed: () {
                                            if (_isPlaying) {
                                              _audioPlayer.pause();
                                            } else {
                                              _audioPlayer.play(
                                                DeviceFileSource(
                                                  path
                                                      .join(
                                                        widget
                                                            .filePath
                                                            .parent
                                                            .path,
                                                        data.question,
                                                      )
                                                      .replaceAll('\\', '/'),
                                                ),
                                              );
                                            }
                                            setState(() {
                                              _isPlaying = !_isPlaying;
                                            });
                                          },
                                          size: 60,
                                          color: AppColors.primaryDark,
                                        )
                                      : Text(
                                          data.question,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                color: AppColors.primaryDark,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().scale(
                      curve: Curves.fastEaseInToSlowEaseOut,
                      duration: const Duration(milliseconds: 300),
                    ),

                    // Bagian Pilihan Jawaban (Expanded agar fleksibel mengisi sisa ruang bawah)
                    Expanded(
                      child:
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
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: Column(
                                    key: ValueKey<int>(activeIndex),
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(data.options.length, (
                                      itemIndex,
                                    ) {
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child:
                                              OptionButton(
                                                    option:
                                                        data.options[itemIndex],
                                                    correctAnswer:
                                                        data.correctAnswer,
                                                    onTap: () {
                                                      setState(() {
                                                        selectedIndex =
                                                            itemIndex;
                                                      });
                                                      onUserAnswered(
                                                        selectedIndex:
                                                            selectedIndex,
                                                        correctAnswerIndex:
                                                            correctAnswerIndex,
                                                        cardId: data.cid,
                                                        totalQuestions:
                                                            state.cards.length,
                                                      );
                                                      if (selectedIndex ==
                                                          correctAnswerIndex) {
                                                        _audioPlayer.play(
                                                          AssetSource(
                                                            "sfx/shidenbeatsmusic-sound-effect-twinklesparkle-115095.mp3",
                                                          ),
                                                        );
                                                        context
                                                            .read<
                                                              QuizGameBloc
                                                            >()
                                                          ..add(
                                                            AnsweringQuestion(
                                                              answer:
                                                                  FlashcardAnswerEnum
                                                                      .correct,
                                                              selectedCard: widget
                                                                  .listCards
                                                                  .where(
                                                                    (card) =>
                                                                        card.id ==
                                                                        data.cid,
                                                                  )
                                                                  .first,
                                                              timeMs:
                                                                  timeSpentPerQuestion,
                                                            ),
                                                          );
                                                      } else {
                                                        _audioPlayer.play(
                                                          AssetSource(
                                                            "sfx/freesound_community-wrong-47985.mp3",
                                                          ),
                                                        );
                                                        context
                                                            .read<
                                                              QuizGameBloc
                                                            >()
                                                          ..add(
                                                            AnsweringQuestion(
                                                              answer:
                                                                  FlashcardAnswerEnum
                                                                      .wrong,
                                                              selectedCard: widget
                                                                  .listCards
                                                                  .where(
                                                                    (card) =>
                                                                        card.id ==
                                                                        data.cid,
                                                                  )
                                                                  .first,
                                                              timeMs:
                                                                  timeSpentPerQuestion,
                                                            ),
                                                          );
                                                      }
                                                    },
                                                    indexOption: itemIndex,
                                                    indexCorrectOption:
                                                        correctAnswerIndex,
                                                    selectedIndex:
                                                        selectedIndex,
                                                  )
                                                  .animate(
                                                    delay: Duration(
                                                      milliseconds:
                                                          80 * itemIndex,
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

  void onUserAnswered({
    required int selectedIndex,
    required int correctAnswerIndex,
    required int cardId,
    required int totalQuestions,
  }) {
    _stopwatch.stop();
    final CardsDetailEntity? selectedCard = widget.listCards
        .where((data) => data.id == cardId)
        .firstOrNull;
    int millisecondsSpent = _stopwatch.elapsed.inMilliseconds;
    timeSpentPerQuestion = millisecondsSpent;

    if (selectedIndex != correctAnswerIndex) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext sheetContext) {
          return WrongAnswerBottombar(
            selectedCard: selectedCard,
            audioPlayer: _audioPlayer,
            playButtonPressed: () async {
              await _audioPlayer.play(
                DeviceFileSource(
                  path
                      .join(
                        widget.filePath.parent.path,
                        selectedCard?.audioPath.first,
                      )
                      .replaceAll('\\', '/'),
                ),
              );
            },
            pauseButtonPressed: () {
              _audioPlayer.pause();
            },
            textButtonPressed: () {
              _audioPlayer.stop();
              Navigator.pop(sheetContext);
              Future.delayed(const Duration(milliseconds: 300), () {
                if (!mounted) return;

                setState(() {
                  this.selectedIndex = -1;

                  if (activeIndex < totalQuestions - 1) {
                    activeIndex++;
                  } else {
                    _timer?.cancel();
                    context.push(
                      '/stats-quiz-game',
                      extra: (totalAnswered: answeredQuestion, isLate: false),
                    );
                  }
                });
              });
            },
          );
        },
      );
    } else {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;

        setState(() {
          answeredQuestion++;
          this.selectedIndex = -1;

          if (activeIndex < totalQuestions - 1) {
            activeIndex++;
          } else {
            _timer?.cancel();
            context.push(
              '/stats-quiz-game',
              extra: (totalAnswered: answeredQuestion, isLate: false),
            );
          }
        });
      });
    }

    _stopwatch.reset();
    _stopwatch.start();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        context.push(
          '/stats-quiz-game',
          extra: (totalAnswered: answeredQuestion, isLate: true),
        );
        _timer?.cancel();
      }
    });
  }
}
