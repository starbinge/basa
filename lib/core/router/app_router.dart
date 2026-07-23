import 'dart:io';

import 'package:basa_app_project/core/data/initial_database/initial_database.dart';
import 'package:basa_app_project/core/router/app_shell.dart';
import 'package:basa_app_project/features/cards/constants/enums/statistics_page_enum.dart';
import 'package:basa_app_project/features/cards/data/repositories/flashcard_repo_impl.dart';
import 'package:basa_app_project/features/cards/domain/entities/card_history_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/repositories/flash_card_repo.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/flash_card/flash_card_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/pages/deck_statistic_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/ending_game_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/flash_card_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/flashcard_summary_stats_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/history_play_card.dart';
import 'package:basa_app_project/features/cards/presentation/pages/main_card_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/quiz_game_page.dart';
import 'package:basa_app_project/features/decks/data/dao/decks_dao.dart';
import 'package:basa_app_project/features/decks/data/repositories/deck_repository_impl.dart';
import 'package:basa_app_project/features/decks/domain/repositories/deck_repository.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/fetching_deck/fetching_deck_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/cards/data/dao/cards_dao.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppShell()),

    GoRoute(
      path: '/cards/:id/:fileName/:deckName/:deckCountry/:activeHour',
      builder: (context, state) => MainCardPage(
        deckId: int.parse(state.pathParameters['id']!),
        fileName: state.pathParameters['fileName']!,
        filePath: state.extra as File,
        deckName: state.pathParameters['deckName']!,
        deckCountry: state.pathParameters['deckCountry']!,
        activeHour: state.pathParameters['activeHour']!,
      ),
      routes: [
        GoRoute(
          path: 'flashcard',
          pageBuilder: (context, state) {
            final extras =
                state.extra
                    as ({
                      List<CardsDetailEntity> listCards,
                      CardsDao cardsDao,
                      File filePath,
                      int startIndex,
                    });

            return MaterialPage(
              child: BlocProvider(
                create: (context) =>
                    FlashCardBloc(
                      flashCardRepo: FlashcardRepoImpl(),
                      cardsDao: extras.cardsDao,
                    )..add(
                      GenerateFlashCard(
                        listCard: extras.listCards,
                        startIndex: extras.startIndex,
                      ),
                    ),
                child: FleshCardPage(
                  deckId: int.parse(state.pathParameters['id']!),
                  fileName: state.pathParameters['fileName']!,
                  filePath: extras.filePath,
                  deckName: state.pathParameters['deckName']!,
                  deckCountry: state.pathParameters['deckCountry']!,
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: 'deck_stats',
          path: 'deckStats/:statsType',
          pageBuilder: (context, state) {
            final extras =
                state.extra
                    as ({FetchingCardsBloc fetchingCardsBloc, File? filePath});
            CardsDao? activeCardsDao;

            if (extras.fetchingCardsBloc.state is FetchingCardIsFinished) {
              activeCardsDao =
                  (extras.fetchingCardsBloc.state as FetchingCardIsFinished)
                      .cardsDao;
            }
            final String? statsTypeString = state.pathParameters['statsType'];
            final FlashCardRepo flashCardRepo = FlashcardRepoImpl();
            final StatisticsPageEnum statsTypeParam = StatisticsPageEnum.values
                .firstWhere(
                  (e) => e.name == statsTypeString,
                  orElse: () => StatisticsPageEnum.accuracy,
                );
            return MaterialPage(
              child: BlocProvider(
                create: (context) {
                  switch (statsTypeParam) {
                    case StatisticsPageEnum.accuracy:
                      return FlashCardBloc(
                        flashCardRepo: flashCardRepo,
                        cardsDao: activeCardsDao,
                      )..add(GettingAccuracyStats());
                    case StatisticsPageEnum.timeConsume:
                      return FlashCardBloc(
                        flashCardRepo: flashCardRepo,
                        cardsDao: activeCardsDao,
                      )..add(GettingTimeConsumeStats());
                  }
                },
                child: DeckStatisticPage(
                  deckName: state.pathParameters['deckName']!,
                  statsType: statsTypeParam,
                  filePath: extras.filePath ?? File(""),
                ),
              ),
            );
          },
        ),
        // GoRoute(
        //   path: 'history',
        //   pageBuilder: (context, state) {
        //     final extra = state.extra as CardHistoryEntity;
        //     return MaterialPage(
        //       child: HistoryPlayCard(cardHistoryEntity: extra),
        //     );
        //   },
        // ),
        GoRoute(
          path: 'quizgame',
          pageBuilder: (context, state) {
            final extra =
                state.extra
                    as ({
                      List<CardsDetailEntity> listCards,
                      CardsDao cardsDao,
                      FlashCardRepo flashCardRepo,
                      File filePath,
                      int startIndex,
                    });

            return MaterialPage(
              child: QuizGamePage(
                listCards: extra.listCards,
                cardsDao: extra.cardsDao,
                flashCardRepo: extra.flashCardRepo,
                filePath: extra.filePath,
                startIndex: extra.startIndex,
              ),
            );
          },
        ),
      ],
    ),
    GoRoute(
      name: 'stats',
      path: '/stats/:deckId/:correctAnswer/:wrongAnswer/:timeSpent',
      pageBuilder: (context, state) {
        final DecksDao _decksDao = RepositoryProvider.of<AppDatabase>(
          context,
        ).decksDao;
        final DeckRepository _deckRepo = DeckRepositoryImpl(
          decksDao: _decksDao,
        );
        return MaterialPage(
          child: BlocProvider(
            create: (context) => FetchingDeckBloc(repository: _deckRepo),
            child: FlashcardSummaryStatsPage(
              deckId: state.pathParameters['deckId']!,
              correctAnswer: state.pathParameters['correctAnswer']!,
              wrongAnswer: state.pathParameters['wrongAnswer']!,
              timeSpent: state.pathParameters['timeSpent']!,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'stats-quiz-game',
      path: '/stats-quiz-game',
      pageBuilder: (context, state) {
        final extra = state.extra as ({int totalAnswered, bool isLate});
        return MaterialPage(
          child: EndingGamePage(
            totalAnswered: extra.totalAnswered,
            isLate: extra.isLate,
          ),
        );
      },
    ),
  ],
);
