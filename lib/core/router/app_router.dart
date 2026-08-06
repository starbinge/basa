import 'package:basa_app_project/core/data/initial_database/initial_database.dart';
import 'package:basa_app_project/core/router/app_shell.dart';
import 'package:basa_app_project/core/data/generated_database/generated_database.dart';
import 'package:basa_app_project/features/cards/constants/enums/statistics_page_enum.dart';
import 'package:basa_app_project/features/cards/data/repositories/accuracy_repo_impl/accuracy_repo_impl.dart';
import 'package:basa_app_project/features/cards/data/repositories/time_consume_impl/time_consume_repo_impl.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/flash_card/flash_card_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/statistics/card_accuracy/card_accuracy_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/statistics/time_consume/time_consume_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/pages/deck_statistic_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/ending_game_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/flash_card_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/flashcard_summary_stats_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/main_card_page.dart';
import 'package:basa_app_project/features/cards/presentation/pages/quiz_game_page.dart';
import 'package:basa_app_project/features/decks/data/dao/decks_dao.dart';
import 'package:basa_app_project/features/decks/data/repositories/deck_repository_impl.dart';
import 'package:basa_app_project/features/decks/domain/repositories/deck_repository.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck/deck_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/cards/domain/entities/cards_detail_entity.dart';
import '../../features/cards/presentation/pages/history_play_card.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppShell()),

    GoRoute(
      path: '/cards/:id/:deckName/:deckCountry/:activeHour',
      builder: (context, state) => MainCardPage(
        deckId: int.parse(state.pathParameters['id']!),
        dbPath: state.extra as String,
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
                      GeneratedDeckDao generatedDeckDao,
                      int startIndex,
                    });

            return MaterialPage(
              child: BlocProvider(
                create: (context) =>
                    FlashCardBloc(
                      generatedDeckDao: extras.generatedDeckDao,
                    )..add(
                      GenerateFlashCard(
                        listCard: extras.listCards,
                        startIndex: extras.startIndex,
                      ),
                    ),
                child: FleshCardPage(
                  deckId: int.parse(state.pathParameters['id']!),
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
                state.extra as ({FetchingCardsBloc fetchingCardsBloc});
            final FetchingCardIsFinished fetchingState =
                extras.fetchingCardsBloc.state as FetchingCardIsFinished;
            final GeneratedDeckDao activeDao = fetchingState.generatedDeckDao;
            final String? statsTypeString = state.pathParameters['statsType'];
            final StatisticsPageEnum statsTypeParam = StatisticsPageEnum.values
                .firstWhere(
                  (e) => e.name == statsTypeString,
                  orElse: () => StatisticsPageEnum.accuracy,
                );

            final accuracyRepo = AccuracyRepoImpl(
              generatedDeckDao: activeDao,
            );
            final timeConsumeRepo = TimeConsumeRepoImpl(
              generatedDeckDao: activeDao,
            );

            switch (statsTypeParam) {
              case StatisticsPageEnum.accuracy:
                return MaterialPage(
                  child: BlocProvider(
                    create: (_) =>
                        CardAccuracyBloc(accuracyCardRepo: accuracyRepo)
                          ..add(FetchAccuracyDetail()),
                    child: DeckStatisticPage(
                      deckName: state.pathParameters['deckName']!,
                      statsType: statsTypeParam,
                    ),
                  ),
                );
              case StatisticsPageEnum.timeConsume:
                return MaterialPage(
                  child: BlocProvider(
                    create: (_) =>
                        TimeConsumeBloc(timeConsumeRepo: timeConsumeRepo)
                          ..add(FetchTimeConsumeDetail()),
                    child: DeckStatisticPage(
                      deckName: state.pathParameters['deckName']!,
                      statsType: statsTypeParam,
                    ),
                  ),
                );
            }
          },
        ),
        GoRoute(
          path: 'history',
          pageBuilder: (context, state) {
            return MaterialPage(
              child: HistoryPlayCard(
                generatedDeckDao: state.extra as GeneratedDeckDao,
              ),
            );
          },
        ),
        GoRoute(
          path: 'quizgame',
          pageBuilder: (context, state) {
            final extra =
                state.extra
                    as ({
                      List<CardsDetailEntity> listCards,
                      GeneratedDeckDao generatedDeckDao,
                      int startIndex,
                    });

            return MaterialPage(
              child: QuizGamePage(
                listCards: extra.listCards,
                generatedDeckDao: extra.generatedDeckDao,
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
            create: (context) => DeckBloc(repository: _deckRepo),
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
