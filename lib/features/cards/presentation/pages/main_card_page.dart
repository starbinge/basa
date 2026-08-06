import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/features/cards/data/repositories/accuracy_repo_impl/accuracy_repo_impl.dart';
import 'package:basa_app_project/features/cards/data/repositories/time_consume_impl/time_consume_repo_impl.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/statistics/card_accuracy/card_accuracy_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/statistics/time_consume/time_consume_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/widgets/shared/vocabulary_list_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/finding_country.dart';
import '../widgets/shared/app_bar_card.dart';
import '../widgets/shared/card_stats.dart';

class MainCardPage extends StatefulWidget {
  const MainCardPage({
    super.key,
    required this.deckId,
    required this.deckName,
    required this.deckCountry,
    required this.activeHour,
    required this.dbPath,
  });

  final int deckId;
  final String deckName;
  final String deckCountry;
  final String activeHour;
  final String dbPath;

  @override
  State<MainCardPage> createState() => _MainCardPageState();
}

class _MainCardPageState extends State<MainCardPage> {
  final ScrollController _scrollController = ScrollController();
  int _startGenerateIndex = 0;

  @override
  Widget build(BuildContext context) {
    final flagEmoji = getCountryFlagEmoji(widget.deckCountry);
    return BlocProvider(
      create: (context) => FetchingCardsBloc()..add(
            FetchCards(
              deckId: widget.deckId,
              deckName: widget.deckName,
              deckCountry: widget.deckCountry,
              dbPath: widget.dbPath,
            ),
          ),
      child: Scaffold(
        body: BlocBuilder<FetchingCardsBloc, FetchingCardsState>(
          builder: (context, state) {
            if (state is FetchingCardIsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FetchingCardIsError) {
              return ErrorPage(
                title: 'Failed to load cards',
                message: state.errorMessage,
              );
            }
            if (state is FetchingCardIsFinished) {
              final List<CardsDetailEntity> listCard =
                  state.cardsEntity.listCard;
              if (listCard.isEmpty) {
                return const ErrorPage(
                  title: 'No Cards Here',
                  message: 'This deck doesn\'t have any cards yet.',
                );
              }
              final List<CardsDetailEntity> displayCards =
                  state.searchResults ?? listCard;

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => CardAccuracyBloc(
                      accuracyCardRepo: AccuracyRepoImpl(
                        generatedDeckDao: state.generatedDeckDao,
                      ),
                    )..add(FetchAccuracySummary()),
                  ),
                  BlocProvider(
                    create: (_) => TimeConsumeBloc(
                      timeConsumeRepo: TimeConsumeRepoImpl(
                        generatedDeckDao: state.generatedDeckDao,
                      ),
                    )..add(FetchWeeklyStreak()),
                  ),
                ],
                child: Builder(
                  builder: (context) => Stack(
                    alignment: AlignmentGeometry.bottomCenter,
                    children: [
                      CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          CardAppBar(
                            flagEmoji: flagEmoji,
                            widget: widget,
                            flashCardButton: () async {
                              await context.push(
                                '${GoRouterState.of(context).matchedLocation}/flashcard',
                                extra: (
                                  listCards: state.cardsEntity.listCard,
                                  generatedDeckDao: state.generatedDeckDao,
                                  startIndex: _startGenerateIndex,
                                ),
                              );
                              if (mounted) {
                                setState(() => _startGenerateIndex += 10);
                                context.read<CardAccuracyBloc>().add(
                                  FetchAccuracySummary(),
                                );
                                context.read<TimeConsumeBloc>().add(
                                  FetchWeeklyStreak(),
                                );
                              }
                            },
                            quizButton: () async {
                              await context.push(
                                '${GoRouterState.of(context).matchedLocation}/quizgame',
                                extra: (
                                  listCards: state.cardsEntity.listCard,
                                  generatedDeckDao: state.generatedDeckDao,
                                  startIndex: _startGenerateIndex,
                                ),
                              );
                              if (mounted) {
                                setState(() => _startGenerateIndex += 10);
                                context.read<CardAccuracyBloc>().add(
                                  FetchAccuracySummary(),
                                );
                                context.read<TimeConsumeBloc>().add(
                                  FetchWeeklyStreak(),
                                );
                              }
                            },
                            historyButton: () {
                              context.push(
                                '${GoRouterState.of(context).matchedLocation}/history',
                                extra: state.generatedDeckDao,
                              );
                            },
                          ),
                          BlocBuilder<CardAccuracyBloc, CardAccuracyState>(
                            builder: (context, accuracyState) {
                              final thisMonthAccuracy =
                                  accuracyState is AccuracySummaryLoaded
                                  ? accuracyState
                                        .thisMonthAccuracy
                                        .accuracyNumber
                                  : 0;
                              final previousMonthAccuracy =
                                  accuracyState is AccuracySummaryLoaded
                                  ? accuracyState
                                        .previousMonthAccuracy
                                        .accuracyNumber
                                  : 0;

                              return BlocBuilder<
                                TimeConsumeBloc,
                                TimeConsumeState
                              >(
                                builder: (context, timeState) {
                                  final streakData =
                                      timeState is StreakDataLoaded
                                      ? timeState.streakData
                                      : <TimeConsumeEntity>[];

                                  return CardStats(
                                    onTapAccuracyStats: () {
                                      final String currentPath =
                                          GoRouterState.of(context).uri.path;

                                      context.push(
                                        '$currentPath/deckStats/accuracy',
                                        extra: (
                                          fetchingCardsBloc: context
                                              .read<FetchingCardsBloc>(),
                                        ),
                                      );
                                    },
                                    onTapTimeConsumeStats: () {
                                      final String currentPath =
                                          GoRouterState.of(context).uri.path;

                                      context.push(
                                        '$currentPath/deckStats/timeConsume',
                                        extra: (
                                          fetchingCardsBloc: context
                                              .read<FetchingCardsBloc>(),
                                        ),
                                      );
                                    },
                                    thisMonthAccuracyStats: thisMonthAccuracy,
                                    previousMonthAccuracyStats:
                                        previousMonthAccuracy,
                                    weeklyTimeConsumeData: streakData,
                                  );
                                },
                              );
                            },
                          ),
                          SliverPadding(
                            padding: const EdgeInsetsGeometry.all(10),
                            sliver: SliverToBoxAdapter(
                              child: VocabularyListContainer(
                                searchValue: (String value) {
                                  context.read<FetchingCardsBloc>().add(
                                    SearchCard(searchParams: value),
                                  );
                                },
                                filteredCards: displayCards,
                                listCards: listCard,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            return const ErrorPage();
          },
        ),
      ),
    );
  }
}
