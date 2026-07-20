import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import '../../domain/usecases/finding_country.dart';
import '../../../../core/data/external_database/external_database_accessor.dart';
import '../../../../core/data/initial_database/initial_database.dart';
import '../widgets/app_bar_card.dart';
import '../widgets/card_stats.dart';
import '../widgets/vocab_bottom_modal.dart';
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
  @override
  void initState() {
    super.initState();
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
                  ? listCard // Kalau belum ngetik apa-apa, pakai list utuh
                  : listCard.where((card) {
                      return card.defaultLanguage.toLowerCase().contains(
                        _findCard.toLowerCase(),
                      );
                    }).toList();

              return Stack(
                alignment: AlignmentGeometry.bottomCenter,
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      CardAppBar(
                        flagEmoji: flagEmoji,
                        widget: widget,
                        flashCardButton: () {
                          final bloc = context.read<FetchingCardsBloc>();
                          context.push(
                            '${GoRouterState.of(context).matchedLocation}/flashcard',
                            extra: bloc,
                          );
                        },
                        quizButton: () {},
                        historyButton: () {
                          context.push(
                            '${GoRouterState.of(context).matchedLocation}/history',
                            extra: state.cardHistoryEntity,
                          );
                        },
                      ),
                      CardStats(
                        onTapAccuracyStats: () {
                          final String currentPath = GoRouterState.of(
                            context,
                          ).uri.path;

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
                          final String currentPath = GoRouterState.of(
                            context,
                          ).uri.path;

                          context.push(
                            '$currentPath/deckStats/timeConsume',
                            extra: (
                              fetchingCardsBloc: context
                                  .read<FetchingCardsBloc>(),
                              filePath: widget.filePath,
                            ),
                          );
                        },
                        thisMonthAccuracyStats:
                            state.thisMonthAccuracyNumber.accuracyNumber,
                        previousMonthAccuracyStats:
                            state.previousMonthAccuracyNumber.accuracyNumber,
                        weeklyTimeConsumeData: state.weeklyTimeConsumeData,
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
                                    color: Colors.grey.withValues(alpha: 0.2),
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
                                    color: Colors.grey.withValues(alpha: 0.2),
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

                                            final int originalIndex = listCard
                                                .indexOf(cardData);
                                            if (_findCard.isNotEmpty ||
                                                _findCard != "") {
                                              final int targetIndex = listCard
                                                  .indexWhere(
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
                                                  playButtonPressed: () {
                                                    final rawPath = path.join(
                                                      widget
                                                          .filePath
                                                          .parent
                                                          .path,
                                                      listCard[itemIndex]
                                                          .audioPath
                                                          .first,
                                                    );
                                                    debugPrint(rawPath);
                                                    _audioPlayer.play(
                                                      DeviceFileSource(
                                                        rawPath.replaceAll(
                                                          '\\',
                                                          '/',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  onLongPressed: () {},
                                                  onCardTap: () {
                                                    showModalBottomSheet(
                                                      showDragHandle: true,
                                                      isScrollControlled: true,
                                                      useSafeArea: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return VocabBottomModal(
                                                          listCard: listCard,
                                                          filePath:
                                                              widget.filePath,
                                                          audioPlayer:
                                                              _audioPlayer,
                                                          cardIndex:
                                                              originalIndex,
                                                        );
                                                      },
                                                    ).then((_) {
                                                      _audioPlayer.stop();
                                                    });
                                                  },
                                                );
                                              }
                                            }
                                            return VocabCard(
                                              listCard: listCard,
                                              index: itemIndex,
                                              playButtonPressed: () {
                                                final rawPath = path.join(
                                                  widget.filePath.parent.path,
                                                  listCard[itemIndex]
                                                      .audioPath
                                                      .first,
                                                );
                                                debugPrint(rawPath);
                                                _audioPlayer.play(
                                                  DeviceFileSource(
                                                    rawPath.replaceAll(
                                                      '\\',
                                                      '/',
                                                    ),
                                                  ),
                                                );
                                              },
                                              onCardTap: () {
                                                showModalBottomSheet(
                                                  showDragHandle: true,
                                                  isScrollControlled: true,
                                                  useSafeArea: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return VocabBottomModal(
                                                      listCard: listCard,
                                                      filePath: widget.filePath,
                                                      audioPlayer: _audioPlayer,
                                                      cardIndex: itemIndex,
                                                    );
                                                  },
                                                ).then((_) {
                                                  _audioPlayer.stop();
                                                });
                                              },
                                              onLongPressed: () {},
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
              );
            }
            return const ErrorPage();
          },
        ),
      ),
    );
  }
}
