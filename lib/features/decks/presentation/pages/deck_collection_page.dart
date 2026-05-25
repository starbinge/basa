import 'package:basa_app_project/core/constants/common_path.dart';
import 'package:basa_app_project/core/widgets/flying_action_button.dart';
import 'package:basa_app_project/core/widgets/status_overlay.dart';
import 'package:basa_app_project/features/decks/domain/entities/deck_entity.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_state.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/fetching_deck/fetching_deck_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/fetching_deck/fetching_deck_event.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/fetching_deck/fetching_deck_state.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_container.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/import_deck_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeckCollectionPage extends StatefulWidget {
  const DeckCollectionPage({super.key});

  @override
  State<DeckCollectionPage> createState() => _DeckCollectionPageState();
}

class _DeckCollectionPageState extends State<DeckCollectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<FetchingDeckBloc>().add(FetchDecksList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<FetchingDeckBloc, FetchingDeckState>(
          builder: (context, state) {
            final List<DeckEntity> deckList = state.deckList;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: deckList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push('/cards/${deckList[index].id}');
                  },
                  child: DeckContainer(
                    indexDeck: index + 1,
                    deckName: deckList[index].deckName,
                    deckLanguage: deckList[index].deckLanguage,
                    iconColor: deckList[index].deckColor,
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FlyingActionButton(
        icon: Icons.add,
        onTap: () {
          final sheetPageController = PageController();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (sheetContext) {
              return BlocListener<DeckImportBloc, DeckImportState>(
                listener: (context, importState) {
                  int? page;
                  if (importState.isLoading) {
                    page = 1;
                  } else if (importState.isError && !importState.isDeckExist) {
                    page = 2;
                  } else if (importState.isDeckExist && importState.isError) {
                    page = 3;
                  } else if (importState.isFinished && !importState.isError) {
                    page = 4;
                    context.read<FetchingDeckBloc>().add(FetchDecksList());
                  }
                  if (page != null) {
                    sheetPageController.animateToPage(
                      page,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: SafeArea(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: sheetPageController,
                    children: [
                      AnkiDeckForm(
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                      StatusOverlay(
                        animation: animationPath + "loading_state.json",
                        hintText: "Importing Deck",
                        isFinished: false,
                      ),
                      StatusOverlay(
                        animation: animationPath + "error_state.json",
                        hintText: "Something Went Wrong",
                        isFinished: true,
                        isFinishedButtonPressed: () =>
                            Navigator.pop(sheetContext),
                      ),
                      StatusOverlay(
                        animation: animationPath + "found_deck_1.json",
                        hintText: "Deck Already Exist",
                        isFinished: true,
                        isFinishedButtonPressed: () =>
                            Navigator.pop(sheetContext),
                      ),
                      StatusOverlay(
                        animation: animationPath + "success.json",
                        hintText: "Deck Imported",
                        isFinished: true,
                        isFinishedButtonPressed: () =>
                            Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
