import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/data/external_database/external_database_accessor.dart';
import 'package:basa_app_project/core/data/initial_database/initial_database.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/features/cards/data/repositories/accuracy_repo_impl/accuracy_repo_impl.dart';
import 'package:basa_app_project/features/cards/data/repositories/flashcard_repo_impl.dart';
import 'package:basa_app_project/features/cards/data/repositories/time_consume_impl/time_consume_repo_impl.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/domain/entities/time_consume_entity/time_consume_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/statistics/card_accuracy/card_accuracy_bloc.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/statistics/time_consume/time_consume_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/finding_country.dart';
import '../widgets/app_bar_card.dart';
import '../widgets/card_stats.dart';
import '../widgets/vocab_cards.dart';

class MainCardPage extends StatefulWidget {
  const MainCardPage({
    super.key,
    required this.deckId,
    required this.fileName,
    required this.filePath,
    required this.deckName,
    required this.deckCountry,
    required this.activeHour,
  });

  final int deckId;
  final String fileName;
  final File filePath;
  final String deckName;
  final String deckCountry;
  final String activeHour;

  @override
  State<MainCardPage> createState() => _MainCardPageState();
}

class _MainCardPageState extends State<MainCardPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  String _findCard = "";
  int _currentPlayingCardIndex = -1;
  int _startGenerateIndex = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _currentPlayingCardIndex = -1;
        });
      }
    });
  }

  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flagEmoji = getCountryFlagEmoji(widget.deckCountry);
    return BlocProvider(
      create: (context) =>
          FetchingCardsBloc(
            databaseAccessor: RepositoryProvider.of<ExternalDatabaseAccessor>(
              context,
            ),
            appDatabase: RepositoryProvider.of<AppDatabase>(context),
          )..add(
            FetchCards(
              deckId: widget.deckId,
              deckName: widget.deckName,
              deckCountry: widget.deckCountry,
              filePath: widget.filePath,
              fileName: widget.fileName,
            ),
          ),
      child: Scaffold(
        body: BlocBuilder<FetchingCardsBloc, FetchingCardsState>(
          builder: (context, state) {
            if (state is FetchingCardIsLoading) {
              return Center(child: CircularProgressIndicator());
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
                return ErrorPage(
                  title: 'No Cards Here',
                  message: 'This deck doesn\'t have any cards yet.',
                );
              }
              final List filteredCards = _findCard.isEmpty
                  ? listCard
                  : listCard.where((card) {
                      return card.defaultLanguage.toLowerCase().contains(
                        _findCard.toLowerCase(),
                      );
                    }).toList();

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => CardAccuracyBloc(
                      accuracyCardRepo: AccuracyRepoImpl(
                        accuracyDao:
                            state.cardsDao.attachedDatabase.accuracyDao,
                      ),
                    )..add(FetchAccuracySummary()),
                  ),
                  BlocProvider(
                    create: (_) => TimeConsumeBloc(
                      timeConsumeRepo: TimeConsumeRepoImpl(
                        timeConsumeDao:
                            state.cardsDao.attachedDatabase.timeConsumeDao,
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
                                  cardsDao: state.cardsDao,
                                  filePath: widget.filePath,
                                  startIndex: _startGenerateIndex,
                                ),
                              );

                              setState(() => _startGenerateIndex += 10);
                              context.read<CardAccuracyBloc>().add(
                                FetchAccuracySummary(),
                              );
                              context.read<TimeConsumeBloc>().add(
                                FetchWeeklyStreak(),
                              );
                            },
                            quizButton: () async {
                              await context.push(
                                '${GoRouterState.of(context).matchedLocation}/quizgame',
                                extra: (
                                  listCards: state.cardsEntity.listCard,
                                  cardsDao: state.cardsDao,
                                  flashCardRepo: FlashcardRepoImpl(),
                                  filePath: widget.filePath,
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
                                          filePath: widget.filePath,
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
                                          filePath: widget.filePath,
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
                            padding: EdgeInsetsGeometry.all(10),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                spacing: 20,
                                children: [
                                  Text(
                                    "Vocabularies",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  SizedBox(height: 10),
                                  SearchBar(
                                    onChanged: (value) {
                                      if (_debounce?.isActive ?? false) {
                                        _debounce?.cancel();
                                      }

                                      _debounce = Timer(
                                        const Duration(milliseconds: 500),
                                        () {
                                          setState(() {
                                            _findCard = value;
                                          });
                                        },
                                      );
                                    },
                                    side: WidgetStatePropertyAll(
                                      BorderSide(
                                        width: 0.8,
                                        color: Colors.grey.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    hintText: "Search Vocabularies...",
                                    elevation: WidgetStatePropertyAll(0),
                                    trailing: {
                                      Padding(
                                        padding: EdgeInsetsGeometry.all(10),
                                        child: Icon(Icons.search),
                                      ),
                                    },
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 0.5,
                                        color: Colors.grey.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    constraints: BoxConstraints(maxHeight: 500),
                                    child: filteredCards.isEmpty
                                        ? const Center(
                                            child: Text(
                                              "Tidak ada kosakata yang cocok",
                                            ),
                                          )
                                        : Scrollbar(
                                            child: ListView.builder(
                                              padding: EdgeInsetsGeometry.zero,
                                              itemCount: filteredCards.length,
                                              itemBuilder: (context, int itemIndex) {
                                                final cardData =
                                                    filteredCards[itemIndex];

                                                final int originalIndex =
                                                    listCard.indexOf(cardData);
                                                if (_findCard.isNotEmpty ||
                                                    _findCard != "") {
                                                  final int targetIndex =
                                                      listCard.indexWhere(
                                                        (card) => card
                                                            .defaultLanguage
                                                            .toLowerCase()
                                                            .contains(
                                                              _findCard
                                                                  .toLowerCase(),
                                                            ),
                                                      );

                                                  if (targetIndex != -1) {
                                                    return VocabCard(
                                                      listCard: listCard,
                                                      index: originalIndex,
                                                    );
                                                  }
                                                }
                                                return VocabCard(
                                                  listCard: listCard,
                                                  index: itemIndex,
                                                );
                                              },
                                            ),
                                          ),
                                  ),
                                ],
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
