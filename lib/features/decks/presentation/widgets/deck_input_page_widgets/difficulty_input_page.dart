import 'package:basa_app_project/core/widgets/text_button_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DifficultyInputPage extends StatelessWidget {
  const DifficultyInputPage({
    super.key,
    required this.theme,
    required PageController pageController,
    required ValueChanged<String> onSelect,
    required String selectedDifficulty,
  }) : _pageController = pageController,
       _onSelect = onSelect,
       _selectedDifficulty = selectedDifficulty;

  static const List<String> difficulties = [
    'beginner',
    'intermediate',
    'advanced',
  ];

  final ThemeData theme;
  final PageController _pageController;
  final ValueChanged<String> _onSelect;
  final String _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Expanded(child: Container()),
        SvgPicture.asset(
          'assets/images/folder.svg',
          height: 64,
        )
            .animate(delay: const Duration(milliseconds: 200))
            .fadeIn(curve: Curves.easeInOut)
            .moveY(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              delay: const Duration(milliseconds: 100),
              begin: 20,
              end: 0,
            ),
        const Text("Choose your difficulty")
            .animate(delay: const Duration(milliseconds: 200))
            .fadeIn(curve: Curves.easeInOut)
            .moveY(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              delay: const Duration(milliseconds: 100),
              begin: 20,
              end: 0,
            ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            for (final difficulty in difficulties)
              _DifficultyOption(
                label: difficulty,
                selected: difficulty == _selectedDifficulty,
                theme: theme,
                onTap: () => _onSelect(difficulty),
              ),
          ],
        )
            .animate(delay: const Duration(milliseconds: 400))
            .fadeIn(curve: Curves.easeInOut)
            .moveY(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              delay: const Duration(milliseconds: 200),
              begin: 20,
              end: 0,
            ),
        Expanded(child: Container()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 20,
          children: [
            Expanded(
              child: TextButtonCustom(
                placeHolder: "Back",
                theme: theme,
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    theme.scaffoldBackgroundColor,
                  ),
                  foregroundColor: WidgetStatePropertyAll(theme.primaryColor),
                  side: WidgetStatePropertyAll(
                    BorderSide(width: 1, color: theme.primaryColor),
                  ),
                ),
                onPressedButton: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            Expanded(
              child: TextButtonCustom(
                theme: theme,
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    _selectedDifficulty.isNotEmpty
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant.withAlpha(120),
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    _selectedDifficulty.isNotEmpty
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant.withAlpha(120),
                  ),
                ),
                onPressedButton: _selectedDifficulty.isNotEmpty
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  const _DifficultyOption({
    required this.label,
    required this.selected,
    required this.theme,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            width: 1,
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
