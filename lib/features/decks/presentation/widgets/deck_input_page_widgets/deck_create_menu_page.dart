import 'package:basa_app_project/core/errors/input_errors.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_bloc.dart';
import 'package:basa_app_project/features/decks/presentation/bloc/deck_import/deck_import_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeckCreateMenuPage extends StatelessWidget {
  const DeckCreateMenuPage({
    super.key,
    required this.theme,
    required this.onGenerateTap,
  });

  final ThemeData theme;
  final VoidCallback onGenerateTap;

  Future<void> _handleImport(BuildContext context) async {
    final bloc = context.read<DeckImportBloc>();
    final String path;
    try {
      path = await bloc.pickFile();
    } on NotEuyFileException {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Only .euy files are supported')));
      return;
    }
    if (path.isEmpty || !context.mounted) return;

    final name = await _showDeckNameDialog(context);
    if (name == null || name.trim().isEmpty || !context.mounted) return;

    context.read<DeckImportBloc>().add(
      ImportDeck(
        deckName: name.trim(),
        deckFilePath: path,
        deckLanguage: "",
        deckColor: Colors.blue.toARGB32(),
      ),
    );
  }

  Future<String?> _showDeckNameDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Deck name"),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Give a name to your deck",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, controller.text.trim()),
              child: const Text("Import"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Text(
                      "What do you want to do?",
                      style: theme.textTheme.titleLarge,
                    ),
                    _MenuOptionCard(
                      theme: theme,
                      icon: Icons.download_outlined,
                      title: "Import Deck (.euy)",
                      subtitle: "Import a deck from a .euy file",
                      onTap: () => _handleImport(context),
                    ),
                    _MenuOptionCard(
                      theme: theme,
                      icon: Icons.auto_awesome_outlined,
                      title: "Create New Deck",
                      subtitle: "Generate a deck with AI",
                      onTap: onGenerateTap,
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

class _MenuOptionCard extends StatelessWidget {
  const _MenuOptionCard({
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final ThemeData theme;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                Icon(icon, size: 40, color: theme.colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
