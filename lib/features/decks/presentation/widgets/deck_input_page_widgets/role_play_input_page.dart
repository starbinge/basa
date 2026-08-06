import 'package:basa_app_project/core/widgets/text_button_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RolePlayInputPage extends StatelessWidget {
  const RolePlayInputPage({
    super.key,
    required this.theme,
    required TextEditingController rolePlayController,
    required PageController pageController,
  }) : _rolePlayController = rolePlayController,
       _pageController = pageController;

  final ThemeData theme;
  final TextEditingController _rolePlayController;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Expanded(child: Container()),
        Icon(
          Icons.theater_comedy_outlined,
          size: 64,
          color: theme.colorScheme.primary,
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
        const Text("Describe your role play")
            .animate(delay: const Duration(milliseconds: 200))
            .fadeIn(curve: Curves.easeInOut)
            .moveY(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              delay: const Duration(milliseconds: 100),
              begin: 20,
              end: 0,
            ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            autofocus: true,
            controller: _rolePlayController,
            maxLines: 4,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Explain what your role play is...",
              hintStyle: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w200),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
              child: ValueListenableBuilder(
                valueListenable: _rolePlayController,
                builder: (context, value, child) {
                  final bool isNotEmpty =
                      _rolePlayController.text.trim().isNotEmpty;
                  return TextButtonCustom(
                    theme: theme,
                    buttonStyle: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        isNotEmpty
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant.withAlpha(120),
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        isNotEmpty
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant.withAlpha(120),
                      ),
                    ),
                    onPressedButton: isNotEmpty
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
