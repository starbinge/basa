import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_event.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_state.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/choose_language_page.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/deck_name_input_page.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/select_deck_file_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnkiDeckForm extends StatefulWidget {
  const AnkiDeckForm({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<AnkiDeckForm> createState() => _AnkiDeckFormState();
}

class _AnkiDeckFormState extends State<AnkiDeckForm> {
  final TextEditingController _deckNameController = TextEditingController();
  final PageController _pageController = PageController();
  String _selectedCountry = "";
  int _selectedColor = Colors.blue.toARGB32();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<DeckImportBloc, DeckImportState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: widget.onPressed,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Center(
                    child: PageView(
                      controller: _pageController,
                      children: [
                        DeckNameInput(
                          theme: theme,
                          deckNameController: _deckNameController,
                          pageController: _pageController,
                          onSelectedColor: (color) {
                            setState(() {
                              _selectedColor = color.toARGB32();
                            });
                          },
                          selectedColor: _selectedColor,
                        ),
                        ChooseLanguagePage(
                          theme: theme,
                          pageController: _pageController,
                          onSelect: (Country) {
                            setState(() {
                              _selectedCountry = Country.name;
                            });
                          },
                          selectedCountry: _selectedCountry,
                        ),
                        SelectDeckFilePage(
                          onTap: () {
                            context.read<DeckImportBloc>().add(SelectFile());
                          },
                          ankiFilePath: state.filePath,
                          pageController: _pageController,
                          onPressedButton: () {
                            context.read<DeckImportBloc>().add(
                              ImportDeck(
                                deckFilePath: state.filePath,
                                deckName: _deckNameController.text,
                                deckLanguage: _selectedCountry,
                                deckColor: _selectedColor,
                              ),
                            );
                          },
                          onTapFilePicker: () {
                            context.read<DeckImportBloc>().add(SelectFile());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
