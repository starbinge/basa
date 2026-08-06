import 'package:basa_app_project/features/decks/presentation/bloc/generate_deck/generate_deck_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/choose_language_page.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/deck_name_input_page.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/difficulty_input_page.dart';
import 'package:basa_app_project/features/decks/presentation/widgets/deck_input_page_widgets/role_play_input_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenerateDeckForm extends StatefulWidget {
  const GenerateDeckForm({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<GenerateDeckForm> createState() => _GenerateDeckFormState();
}

class _GenerateDeckFormState extends State<GenerateDeckForm> {
  final TextEditingController _deckNameController = TextEditingController();
  final TextEditingController _rolePlayController = TextEditingController();
  final PageController _pageController = PageController();
  String _selectedCountry = "";
  String _selectedDifficulty = "";
  int _selectedColor = Colors.blue.toARGB32();

  @override
  void dispose() {
    _deckNameController.dispose();
    _rolePlayController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                    DifficultyInputPage(
                      theme: theme,
                      pageController: _pageController,
                      onSelect: (difficulty) {
                        setState(() {
                          _selectedDifficulty = difficulty;
                        });
                      },
                      selectedDifficulty: _selectedDifficulty,
                    ),
                    RolePlayInputPage(
                      theme: theme,
                      rolePlayController: _rolePlayController,
                      pageController: _pageController,
                    ),
                    _GenerateConfirmPage(
                      theme: theme,
                      deckName: _deckNameController.text,
                      language: _selectedCountry,
                      difficulty: _selectedDifficulty,
                      rolePlay: _rolePlayController.text,
                      onGenerate: () {
                        context.read<GenerateDeckBloc>().add(
                          GenerateDeck(
                            deckName: _deckNameController.text,
                            colorDeck: _selectedColor,
                            countryDeck: _selectedCountry,
                            defaultLanguage: "Indonesia",
                            rolePlay: _rolePlayController.text,
                            targetLang: _selectedCountry,
                            difficulty: _selectedDifficulty,
                          ),
                        );
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
  }
}

class _GenerateConfirmPage extends StatelessWidget {
  const _GenerateConfirmPage({
    required this.theme,
    required this.deckName,
    required this.language,
    required this.difficulty,
    required this.rolePlay,
    required this.onGenerate,
  });

  final ThemeData theme;
  final String deckName;
  final String language;
  final String difficulty;
  final String rolePlay;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 12,
      children: [
        Expanded(child: Container()),
        Icon(
          Icons.rocket_launch_outlined,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        Text("Ready to generate your deck", style: theme.textTheme.titleMedium),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                _SummaryRow(label: "Deck name", value: deckName, theme: theme),
                _SummaryRow(label: "Language", value: language, theme: theme),
                _SummaryRow(
                  label: "Difficulty",
                  value: difficulty,
                  theme: theme,
                ),
                _SummaryRow(label: "Role play", value: rolePlay, theme: theme),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onGenerate,
              child: const Text("Generate"),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
