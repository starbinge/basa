import 'dart:io';

import 'package:basa_app_project/core/constants/common_path.dart';
import 'package:basa_app_project/core/utils/file_picker.dart';
import 'package:basa_app_project/core/widgets/flying_action_button.dart';
import 'package:basa_app_project/core/widgets/status_overlay.dart';
import 'package:basa_app_project/features/decks/data/repositories/deck_repository_impl.dart';
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
import 'package:path/path.dart' as path;

import '../../../../core/data/initial_database/initial_database.dart';
import '../../domain/repositories/deck_repository.dart';

class DeckCollectionPage extends StatefulWidget {
  const DeckCollectionPage({super.key});

  @override
  State<DeckCollectionPage> createState() => _DeckCollectionPageState();
}

class _DeckCollectionPageState extends State<DeckCollectionPage> {
  late final FetchingDeckBloc _fetchingDeckBloc;

  @override
  void initState() {
    super.initState();
    // 1. Grab the fully prepared repository instantly from the global context
    final repository = RepositoryProvider.of<DeckRepository>(context);

    _fetchingDeckBloc = FetchingDeckBloc(repository: repository);

    // 2. Safely trigger your event after the frame completes its first draw
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchingDeckBloc.add(FetchDecksList());
    });
  }

  @override
  void dispose() {
    _fetchingDeckBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _fetchingDeckBloc,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<FetchingDeckBloc, FetchingDeckState>(
            builder: (context, state) {
              if (state.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
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
                      GoRouter.of(context).push(
                        '/cards/${deckList[index].id}/collection.anki2/${deckList[index].deckName}/${deckList[index].deckLanguage}/${deckList[index].activeHour}',
                        extra: File(
                          path.join(
                            deckList[index].extractedPath,
                            'collection.anki2',
                          ),
                        ),
                      );
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
                return BlocProvider.value(
                  value: _fetchingDeckBloc,
                  child: BlocProvider<DeckImportBloc>(
                    create: (context) {
                      final decksDao = RepositoryProvider.of<AppDatabase>(
                        context,
                      ).decksDao;
                      final repository = DeckRepositoryImpl(decksDao: decksDao);
                      return DeckImportBloc(
                        repository: repository,
                        filePicker: FilePickerService(),
                      );
                    },
                    child: BlocListener<DeckImportBloc, DeckImportState>(
                      listener: (context, importState) {
                        int? page;
                        if (importState.isLoading) {
                          page = 1;
                        } else if (importState.isError &&
                            !importState.isDeckExist) {
                          page = 2;
                        } else if (importState.isDeckExist &&
                            importState.isError) {
                          page = 3;
                        } else if (importState.isFinished &&
                            !importState.isError) {
                          page = 4;
                          context.read<FetchingDeckBloc>().add(
                            FetchDecksList(),
                          );
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
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
