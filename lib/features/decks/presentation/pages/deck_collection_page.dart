import 'package:basa_app_project/core/constants/common_path.dart';
import 'package:basa_app_project/core/pages/error_page.dart';
import 'package:basa_app_project/core/utils/file_picker.dart';
import 'package:basa_app_project/core/widgets/flying_action_button.dart';
import 'package:basa_app_project/core/widgets/status_overlay.dart';
import 'package:basa_app_project/features/decks/data/repositories/deck_repository_impl.dart';
import 'package:basa_app_project/features/decks/data/repositories/generate_deck_repository_impl.dart';
import 'package:basa_app_project/features/decks/domain/entities/deck_entity.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck/deck_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck/deck_event.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck/deck_state.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_state.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/generate_deck/generate_deck_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_container.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/deck_create_menu_page.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/generate_deck_form.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/initial_database/initial_database.dart';
import '../../domain/repositories/deck_repository.dart';

class DeckCollectionPage extends StatefulWidget {
  const DeckCollectionPage({super.key});

  @override
  State<DeckCollectionPage> createState() => _DeckCollectionPageState();
}

class _DeckCollectionPageState extends State<DeckCollectionPage> {
  late final DeckBloc _deckBloc;

  @override
  void initState() {
    super.initState();
    final repository = RepositoryProvider.of<DeckRepository>(context);

    _deckBloc = DeckBloc(repository: repository);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deckBloc.add(FetchDecksList());
    });
  }

  @override
  void dispose() {
    _deckBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _deckBloc,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<DeckBloc, DeckState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<DeckEntity> deckList = state.deckList;
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: deckList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (deckList[index].dbPath.isEmpty) return;
                      GoRouter.of(context).push(
                        '/cards/${deckList[index].id}/${deckList[index].deckName}/${deckList[index].deckLanguage}/${deckList[index].activeHour}',
                        extra: deckList[index].dbPath,
                      );
                    },
                    child:
                        DeckContainer(
                          indexDeck: index + 1,
                          deckName: deckList[index].deckName,
                          deckLanguage: deckList[index].deckLanguage,
                          iconColor: deckList[index].deckColor,
                        ).animate().scale(
                          delay: (Duration(milliseconds: index * 200)),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.fastEaseInToSlowEaseOut,
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
                  value: _deckBloc,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<DeckImportBloc>(
                        create: (context) {
                          final decksDao = RepositoryProvider.of<AppDatabase>(
                            context,
                          ).decksDao;
                          final repository = DeckRepositoryImpl(
                            decksDao: decksDao,
                          );
                          return DeckImportBloc(
                            repository: repository,
                            filePicker: FilePickerService(),
                          );
                        },
                      ),
                      BlocProvider<GenerateDeckBloc>(
                        create: (context) {
                          final decksDao = RepositoryProvider.of<AppDatabase>(
                            context,
                          ).decksDao;
                          return GenerateDeckBloc(
                            generateDeckRepo: GenerateDeckRepositoryImpl(
                              dio: RepositoryProvider.of<Dio>(context),
                            ),
                            deckRepository: DeckRepositoryImpl(
                              decksDao: decksDao,
                            ),
                          );
                        },
                      ),
                    ],
                    child: BlocListener<GenerateDeckBloc, GenerateDeckState>(
                      listener: (context, generateState) {
                        int? page;
                        if (generateState is GenerateDeckLoading) {
                          page = 6;
                        } else if (generateState is GenerateDeckIsExist) {
                          page = 3;
                        } else if (generateState is GenerateDeckIsError) {
                          page = 7;
                        } else if (generateState is GenerateDeckIsFinished) {
                          page = 8;
                          context.read<DeckBloc>().add(FetchDecksList());
                        }
                        if (page != null) {
                          sheetPageController.animateToPage(
                            page,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: BlocListener<DeckImportBloc, DeckImportState>(
                      listener: (context, importState) {
                        int? page;
                        if (importState.isLoading) {
                          page = 1;
                        } else if (importState.isError &&
                            !importState.isDeckExist) {
                          final rootNavigator = Navigator.of(
                            sheetContext,
                            rootNavigator: true,
                          );
                          Navigator.pop(sheetContext);
                          rootNavigator.push(
                            MaterialPageRoute(
                              builder: (_) => ErrorPage(
                                title: 'Failed to import deck',
                                message: importState.errorMessage,
                              ),
                            ),
                          );
                          return;
                        } else if (importState.isDeckExist &&
                            importState.isError) {
                          page = 3;
                        } else if (importState.isFinished &&
                            !importState.isError) {
                          page = 4;
                          context.read<DeckBloc>().add(
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
                            DeckCreateMenuPage(
                              theme: Theme.of(context),
                              onGenerateTap: () {
                                sheetPageController.animateToPage(
                                  5,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                            const StatusOverlay(
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
                            GenerateDeckForm(
                              onPressed: () => Navigator.pop(sheetContext),
                            ),
                            const StatusOverlay(
                              animation: animationPath + "loading_state.json",
                              hintText: "Generating Deck",
                              isFinished: false,
                            ),
                            BlocBuilder<GenerateDeckBloc, GenerateDeckState>(
                              builder: (context, generateState) {
                                final String message = generateState
                                        is GenerateDeckIsError
                                    ? generateState.errorMessage
                                    : "Something Went Wrong";
                                return StatusOverlay(
                                  animation:
                                      animationPath + "error_state.json",
                                  hintText: message,
                                  isFinished: true,
                                  isFinishedButtonPressed: () =>
                                      Navigator.pop(sheetContext),
                                );
                              },
                            ),
                            StatusOverlay(
                              animation: animationPath + "success.json",
                              hintText: "Deck Generated",
                              isFinished: true,
                              isFinishedButtonPressed: () =>
                                  Navigator.pop(sheetContext),
                            ),
                          ],
                        ),
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
