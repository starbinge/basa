import 'dart:ffi';
import 'dart:io';

import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/core/widgets/button.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/usecases/track_per_card_timer.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/flash_card/flash_card_bloc.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/enums/flashcard_answer_enum.dart';
import '../widgets/flash_card_slider.dart';

class FleshCardPage extends StatefulWidget {
  const FleshCardPage({
    super.key,
    required this.deckId,
    required this.deckName,
    required this.deckCountry,
    required this.fileName,
    required this.filePath,
  });

  final int deckId;
  final String deckName;
  final String deckCountry;
  final String fileName;
  final File filePath;

  @override
  State<FleshCardPage> createState() => _FleshCardPageState();
}

class _FleshCardPageState extends State<FleshCardPage> {
  final Stopwatch _sessionStopWatch = Stopwatch();
  final TrackPerCardTimer _cardTimer = TrackPerCardTimer();
  final PageController _pageController = PageController();
  final FlipCardController _flipCardController = FlipCardController();
  bool isThisBack = false;
  int activeIndex = 0;
  int wrongAnswer = 0;
  int correctAnswer = 0;

  @override
  void initState() {
    super.initState();
    _sessionStopWatch.start();
    _cardTimer.start();
  }

  @override
  void dispose() {
    _sessionStopWatch.start();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FlashCardBloc, FlashCardState>(
        builder: (context, state) {
          if (state is FlashCardIsLoading) return CircularProgressIndicator();
          if (state is FLashCardIsError)
            return ErrorPage(
              title: 'Flashcard error',
              message: state.errorMessage,
            );
          if (state is FLashCardIsFinished) {
            final List<CardsDetailEntity> flashCards = state.listCard;
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Center(child: Text("Flash Card")),
                  ),
                  Expanded(
                    child: FlashCardSlider(
                      itemCount: flashCards.length,
                      flashCards: flashCards,
                      flipCardController: _flipCardController,
                      pageController: _pageController,
                      onCardFlipped: (isBack) {
                        setState(() {
                          isThisBack = isBack;
                        });
                        debugPrint(isThisBack.toString());
                      },
                      onPageChanged: (int value) {
                        activeIndex = value;
                        isThisBack = false;
                        _cardTimer
                          ..stop()
                          ..start();
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          style: ButtonStyle(
                            iconSize: WidgetStatePropertyAll(30),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              isThisBack
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                          onPressed: isThisBack
                              ? () => onPressedAction(
                                  answer: FlashcardAnswerEnum.wrong,
                                  cardLength: flashCards.length,
                                  flashCards: flashCards[activeIndex],
                                )
                              : null,
                          icon: Icon(Icons.close),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            iconSize: WidgetStatePropertyAll(30),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.black,
                            ),
                          ),
                          onPressed: () {
                            _flipCardController.toggleCard();
                          },
                          icon: Icon(Icons.flip_camera_android),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            iconSize: WidgetStatePropertyAll(30),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              isThisBack
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                          onPressed: isThisBack
                              ? () => onPressedAction(
                                  answer: FlashcardAnswerEnum.correct,
                                  cardLength: flashCards.length,
                                  flashCards: flashCards[activeIndex],
                                )
                              : null,
                          icon: Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const ErrorPage();
        },
      ),
    );
  }

  void onPressedAction({
    required FlashcardAnswerEnum answer,
    required int cardLength,
    required CardsDetailEntity flashCards,
  }) {
    _cardTimer.stop();
    context.read<FlashCardBloc>().add(
      AnsweringFlashCard(
        selectedCard: flashCards,
        answer: answer,
        timeMs: _cardTimer.elapsedMilliseconds,
      ),
    );

    if (cardLength - 1 == activeIndex) {
      setState(() {
        switch (answer) {
          case FlashcardAnswerEnum.correct:
            correctAnswer += 1;
          case FlashcardAnswerEnum.wrong:
            wrongAnswer += 1;
        }
        isThisBack = false;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;

        context.read<FetchingCardsBloc>().add(
          FetchCards(
            deckId: widget.deckId,
            deckName: widget.deckName,
            deckCountry: widget.deckCountry,
            filePath: widget.filePath,
            fileName: widget.fileName,
          ),
        );
        final String _timeSpent = _sessionStopWatch.elapsed.inSeconds
            .toString();
        GoRouter.of(context).pushReplacement(
          '/stats/${widget.deckId}/$correctAnswer/$wrongAnswer/$_timeSpent',
        );
      });
    } else {
      setState(() {
        switch (answer) {
          case FlashcardAnswerEnum.correct:
            correctAnswer += 1;
          case FlashcardAnswerEnum.wrong:
            wrongAnswer += 1;
        }
        isThisBack = false;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
