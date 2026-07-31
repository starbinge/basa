import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/core/widgets/timer_container.dart';
import 'package:basa_app_project/features/cards/data/dao/cards_dao/cards_dao.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/flash_card_repo.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();
  int answeredQuestion = 0;

  @override
  void initState() {
    super.initState();
    AudioPlayer.global.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.game,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
        iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
      ),
    );
    _audioPlayer.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
      ),
    );

    _sfxPlayer.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
      ),
    );
    _initAndPlayBgm();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _bgmPlayer.stop();
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          QuizGameBloc(
            cardsDao: widget._cardsDao,
            flashCardRepo: widget._flashCardRepo,
          )..add(
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
                      audioPlayer: _audioPlayer,
                    ),

                    AnswerOptionSection(
                      listCards: widget.listCards,
                      filePath: widget.filePath,
                      audioPlayer: _sfxPlayer,
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

  Future<void> _initAndPlayBgm() async {
    await _bgmPlayer.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
      ),
    );
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

    await _bgmPlayer.setVolume(0.1);

    await _bgmPlayer.play(
      AssetSource('sfx/sondangsirait419-1-efek-sound-1-220034.mp3'),
    );
  }
}
