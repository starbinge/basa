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
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset >= 2000) {
        if (!_showBackToTopButton) {
          setState(() {
            _showBackToTopButton = true;
          });
        }
      } else {
        if (_showBackToTopButton) {
          setState(() {
            _showBackToTopButton = false;
          });
        }
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
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  CardAppBar(flagEmoji: flagEmoji, widget: widget),
                  SliverToBoxAdapter(
                    child: TextButton(
                      onPressed: () {
                        final bloc = context.read<FetchingCardsBloc>();
                        context.push(
                          '${GoRouterState.of(context).matchedLocation}/flashcard',
                          extra: bloc,
                        );
                      },
                      child: Text("Flash Card"),
                    ),
                  ),
                  CardStats(
                    onTapAccuracyStats: () {
                      final String currentPath = GoRouterState.of(
                        context,
                      ).uri.path;

                      context.push(
                        '$currentPath/deckStats/accuracy',
                        extra: (
                          fetchingCardsBloc: context.read<FetchingCardsBloc>(),
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
                          fetchingCardsBloc: context.read<FetchingCardsBloc>(),
                          filePath: widget.filePath,
                        ),
                      );
                    },
                  ),
                  SliverPadding(
                    padding: EdgeInsetsGeometry.all(10),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((
                        BuildContext context,
                        int index,
                      ) {
                        return VocabCard(
                          listCard: listCard,
                          index: index,
                          playButtonPressed: () {
                            final rawPath = path.join(
                              widget.filePath.parent.path,
                              listCard[index].audioPath.first,
                            );
                            debugPrint(rawPath);
                            _audioPlayer.play(
                              DeviceFileSource(rawPath.replaceAll('\\', '/')),
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
                                  cardIndex: index,
                                );
                              },
                            ).then((_) {
                              _audioPlayer.stop();
                            });
                          },
                          onLongPressed: () {},
                        );
                      }),
                    ),
                  ),
                ],
              );
            }
            return const ErrorPage();
          },
        ),
        floatingActionButton: _showBackToTopButton
            ? FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              )
            : null,
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }
}
