import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:basa_app_project/features/cards/data/repositories/card_repo_impl.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:basa_app_project/features/cards/presentation/bloc/fetching_card/fetching_cards_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import '../../domain/usecases/finding_country.dart';
import '../../../../core/data/external_database/external_database_accessor.dart';
import '../../../../core/data/initial_database/initial_database.dart';
import '../../../../core/widgets/stats_card.dart';
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
  });

  final int deckId;
  final String fileName;
  final File filePath;
  final String deckName;
  final String deckCountry;

  @override
  State<MainCardPage> createState() => _MainCardPageState();
}

class _MainCardPageState extends State<MainCardPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

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
              return CircularProgressIndicator();
            }
            if (state is FetchingCardIsError) {
              debugPrint(state.errorMessage);
              return Center(child: Text("Something Error"));
            }
            if (state is FetchingCardIsFinished) {
              final List<CardsDetailEntity> listCard =
                  state.cardsEntity.listCard;
              if (listCard.isEmpty) {
                return Center(child: Text("No Cards Here"));
              }
              return CustomScrollView(
                slivers: [
                  CardAppBar(flagEmoji: flagEmoji, widget: widget),
                  CardStats(),
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
                                  widget: widget,
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
            return Center(child: Text("Something Went Wrong"));
          },
        ),
      ),
    );
  }
}
